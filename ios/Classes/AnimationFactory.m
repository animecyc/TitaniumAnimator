/**
 * A drop-in animation replacement for Titanium
 *
 * Copyright (C) 2013 Seth Benjamin
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
#import "AnimationFactory.h"

@implementation TiViewProxy (TiViewProxyAnimationFactory)

- (BOOL)isAnimating
{
    return [TiUtils boolValue:[self valueForKey:@"__animating"] def:NO];
}

- (void)setAnimating:(BOOL)animating
{
    [self setValue:NUMBOOL(animating) forKey:@"__animating"];
}

@end

@implementation AnimationFactory

- (void)animateUsingProxy:(TiViewProxy *)proxy andProperties:(NSDictionary *)properties completed:(KrollCallback *)callback
{
    BOOL allowTouches = [TiUtils boolValue:[properties objectForKey:@"allowTouches"] def:NO];
    
    if (! allowTouches && [proxy isAnimating])
    {
        return;
    }
    else if(allowTouches && [proxy isAnimating]) {
        [proxy.view.layer removeAllAnimations];
    }
    
    [proxy setAnimating:YES];
    
    // Dimensions
    
    TiDimension left = [TiUtils dimensionValue:@"left" properties:properties def:TiDimensionUndefined];
    TiDimension right = [TiUtils dimensionValue:@"right" properties:properties def:TiDimensionUndefined];
    TiDimension top = [TiUtils dimensionValue:@"top" properties:properties def:TiDimensionUndefined];
    TiDimension bottom = [TiUtils dimensionValue:@"bottom" properties:properties def:TiDimensionUndefined];
    TiDimension width = [TiUtils dimensionValue:@"width" properties:properties def:TiDimensionUndefined];
    TiDimension height = [TiUtils dimensionValue:@"height" properties:properties def:TiDimensionUndefined];
    
    // Cosmetic
    
    NSNumber *opacity = [TiUtils numberFromObject:[properties objectForKey:@"opacity"]];
    NSNumber *rotate = [TiUtils numberFromObject:[properties objectForKey:@"rotate"]];
    TiColor *color = [TiUtils colorValue:[properties objectForKey:@"color"]];
    TiColor *backgroundColor = [TiUtils colorValue:[properties objectForKey:@"backgroundColor"]];
    TiProxy *transform = [properties objectForKey:@"transform"];
    
    // Options
    
    NSNumber *duration = [TiUtils numberFromObject:[properties objectForKey:@"duration"]];
    NSNumber *delay = [TiUtils numberFromObject:[properties objectForKey:@"delay"]];
    NSNumber *easing = [TiUtils numberFromObject:[properties objectForKey:@"easing"]];
    TiViewProxy *parent = [properties objectForKey:@"parentForAnimation"];
    BOOL siblings = [TiUtils boolValue:[properties objectForKey:@"siblings"] def:NO];
    BOOL opaque = [TiUtils boolValue:[properties objectForKey:@"opaque"] def:NO];
    BOOL originalOpaque = [proxy.view isOpaque];
    BOOL autoreverse = [TiUtils boolValue:[properties objectForKey:@"autoreverse"] def:NO];
    
    // Ensure required values have defaults
    
    delay = (delay != nil ? delay : NUMINT(0));
    duration = (duration != nil ? duration : NUMINT(1000));
    easing = (easing != nil ? easing : NUMINT(EASING_LINEAR));
    opaque = opacity != nil && [opacity floatValue] < 1 ? NO : opaque;
    
    AHEasingFunction easingFunc = [self getEasingFunc:easing];
    double animationDelay = delay > 0 ? ([delay doubleValue] / 1000) : 0;
    double animationDuration = ([duration doubleValue] / 1000);
    
    // Given the above setting `opaque` to YES
    // can give us a more performant animation
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animationDelay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^(void){
        [proxy.view setOpaque:opaque];
        
        [CATransaction begin];
        [CATransaction setValue:[NSNumber numberWithDouble:animationDuration] forKey:kCATransactionAnimationDuration];
        [CATransaction setCompletionBlock:^
         {
             if (!TiDimensionIsUndefined(top) || !TiDimensionIsUndefined(left) || !TiDimensionIsUndefined(bottom) || !TiDimensionIsUndefined(right) || !TiDimensionIsUndefined(width) || !TiDimensionIsUndefined(height))
             {
                 if (siblings)
                 {
                     TiViewProxy *parentToAnimate = nil;
                     
                     if ([parent isKindOfClass:[TiViewProxy class]])
                     {
                         parentToAnimate = parent;
                     }
                     else
                     {
                         parentToAnimate = proxy.parent;
                     }
                     
                     if (proxy.parent != parentToAnimate)
                     {
                         [proxy.parent.children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
                          {
                              TiViewProxy *sibling = (TiViewProxy *)obj;
                              
                              [sibling.view setClipsToBounds:YES];
                              [sibling.view removeEasingFunctionForKeyPath:@"frame"];
                          }];
                     }
                     
                     [parentToAnimate.children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
                      {
                          TiViewProxy *sibling = (TiViewProxy *)obj;
                          
                          [sibling.view setClipsToBounds:YES];
                          [sibling.view removeEasingFunctionForKeyPath:@"frame"];
                      }];
                     
                     [proxy.children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
                      {
                          TiViewProxy *sibling = (TiViewProxy *)obj;
                          
                          if (! [sibling isAnimating])
                          {
                              [sibling.view setEasingFunction:easingFunc forKeyPath:@"frame"];
                          }
                      }];
                     
                     if ([parentToAnimate isKindOfClass:[TiUIScrollViewProxy class]])
                     {
                         TiUIScrollViewProxy *scrollViewProxy = (TiUIScrollViewProxy *)parentToAnimate;
                         TiUIScrollView *scrollView = (TiUIScrollView *)[scrollViewProxy view];
                         
                         [[scrollView wrapperView] removeEasingFunctionForKeyPath:@"frame"];
                     }
                 }
                 else
                 {
                     [proxy.view removeEasingFunctionForKeyPath:@"frame"];
                 }
                 
                 if (!TiDimensionIsUndefined(top)) [proxy replaceValue:[properties objectForKey:@"top"] forKey:@"top" notification:NO];
                 if (!TiDimensionIsUndefined(left)) [proxy replaceValue:[properties objectForKey:@"left"] forKey:@"left" notification:NO];
                 if (!TiDimensionIsUndefined(bottom)) [proxy replaceValue:[properties objectForKey:@"bottom"] forKey:@"bottom" notification:NO];
                 if (!TiDimensionIsUndefined(right)) [proxy replaceValue:[properties objectForKey:@"right"] forKey:@"right" notification:NO];
                 if (!TiDimensionIsUndefined(width)) [proxy replaceValue:[properties objectForKey:@"width"] forKey:@"width" notification:NO];
                 if (!TiDimensionIsUndefined(height)) [proxy replaceValue:[properties objectForKey:@"height"] forKey:@"height" notification:NO];
             }
             
             if (transform != nil) [proxy.view removeEasingFunctionForKeyPath:@"transform"];
             if (opacity != nil) [proxy.view removeEasingFunctionForKeyPath:@"alpha"];
             if (backgroundColor != nil) [proxy.view removeEasingFunctionForKeyPath:@"backgroundColor"];
             
             [proxy.view setOpaque:originalOpaque];
             [proxy setAnimating:NO];
             
             if (callback != nil) [proxy _fireEventToListener:@"animated" withObject:nil listener:callback thisObject:proxy];
         }];
        
        if (rotate != nil)
        {
            double rotateFrom = degreesToRadians([[proxy valueForKey:@"__rotation"] floatValue]);
            double rotateTo = rotateFrom + degreesToRadians([rotate floatValue]);
            
            CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation
                                                    animationWithKeyPath:@"transform.rotation.z"
                                                    function:easingFunc
                                                    fromValue:rotateFrom
                                                    toValue:rotateTo];
            
            [rotateAnimation setDuration:animationDuration];
            
            [proxy.view.layer addAnimation:rotateAnimation forKey:@"rotation"];
            
            if (fmodf(radiansToDegrees(rotateTo), 360) == 0)
            {
                [proxy setValue:[NSNumber numberWithInteger:0] forKey:@"__rotation"];
            }
            else
            {
                [proxy setValue:[NSNumber numberWithDouble:radiansToDegrees(rotateTo)] forKey:@"__rotation"];
            }
            
            [proxy.view setVirtualParentTransform:CGAffineTransformRotate([proxy.view transform], rotateTo - rotateFrom)];
        }
        
        if (color != nil)
        {
            // If the label being animated has an appropriate CATextLayer
            // attached to it and responds to the setTextColor the below
            // should animate as expected. At this time there is no support
            // for any of the easing functions
            
            [proxy setValue:color forKey:@"color"];
        }
        
        if (transform != nil || !TiDimensionIsUndefined(top) || !TiDimensionIsUndefined(left) ||
            !TiDimensionIsUndefined(bottom) || !TiDimensionIsUndefined(right) || !TiDimensionIsUndefined(width) ||
            !TiDimensionIsUndefined(height) || opacity != nil || backgroundColor != nil || color != nil)
        {
            UIViewAnimationOptions animationOptions = UIViewAnimationOptionBeginFromCurrentState;
            
            if(allowTouches) animationOptions |= UIViewAnimationOptionAllowUserInteraction;
            if(autoreverse) animationOptions |= UIViewAnimationOptionAutoreverse;
            
            [UIView animateWithDuration:animationDuration delay:0 options:animationOptions animations:^{
                if (transform != nil)
                {
                    [proxy.view setEasingFunction:easingFunc forKeyPath:@"transform"];
                    [proxy.view setTransform_:transform];
                }
                
                if (!TiDimensionIsUndefined(top) || !TiDimensionIsUndefined(left) || !TiDimensionIsUndefined(bottom) || !TiDimensionIsUndefined(right) || !TiDimensionIsUndefined(width) || !TiDimensionIsUndefined(height))
                {
                    LayoutConstraint *layoutProperties = [proxy layoutProperties];
                    
                    if (!TiDimensionIsUndefined(top)) layoutProperties->top = top;
                    if (!TiDimensionIsUndefined(left)) layoutProperties->left = left;
                    if (!TiDimensionIsUndefined(bottom)) layoutProperties->bottom = bottom;
                    if (!TiDimensionIsUndefined(right)) layoutProperties->right = right;
                    if (!TiDimensionIsUndefined(width)) layoutProperties->width = width;
                    if (!TiDimensionIsUndefined(height)) layoutProperties->height = height;
                    
                    object_setInstanceVariable(proxy, "_layoutProperties", &layoutProperties);
                    
                    if (siblings)
                    {
                        TiViewProxy *parentToAnimate = nil;
                        
                        if ([parent isKindOfClass:[TiViewProxy class]])
                        {
                            parentToAnimate = parent;
                        }
                        else
                        {
                            parentToAnimate = proxy.parent;
                        }
                        
                        if (proxy.parent != parentToAnimate)
                        {
                            [proxy.parent.children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
                             {
                                 TiViewProxy *sibling = (TiViewProxy *)obj;
                                 
                                 [sibling.view setClipsToBounds:NO];
                                 [sibling.view setEasingFunction:easingFunc forKeyPath:@"frame"];
                             }];
                        }
                        
                        [parentToAnimate.children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
                         {
                             TiViewProxy *sibling = (TiViewProxy *)obj;
                             
                             [sibling.view setClipsToBounds:NO];
                             [sibling.view setEasingFunction:easingFunc forKeyPath:@"frame"];
                         }];
                        
                        [proxy.children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
                         {
                             TiViewProxy *sibling = (TiViewProxy *)obj;
                             
                             if (! [sibling isAnimating])
                             {
                                 [sibling.view setEasingFunction:easingFunc forKeyPath:@"frame"];
                             }
                         }];
                        
                        if ([parentToAnimate isKindOfClass:[TiUIScrollViewProxy class]])
                        {
                            TiUIScrollViewProxy *scrollViewProxy = (TiUIScrollViewProxy *)parentToAnimate;
                            TiUIScrollView *scrollView = (TiUIScrollView *)[scrollViewProxy view];
                            
                            [[scrollView wrapperView] setEasingFunction:easingFunc forKeyPath:@"frame"];
                            [scrollViewProxy contentsWillChange];
                            [scrollView handleContentSize];
                        }
                        else if (parentToAnimate != nil)
                        {
                            [parentToAnimate layoutChildren:NO];
                        }
                    }
                    else
                    {
                        [proxy.view setEasingFunction:easingFunc forKeyPath:@"frame"];
                        [proxy relayout];
                    }
                }
                
                if (opacity != nil)
                {
                    [proxy.view setEasingFunction:easingFunc forKeyPath:@"alpha"];
                    [proxy setValue:opacity forKey:@"opacity"];
                }
                
                if (backgroundColor != nil)
                {
                    [proxy.view setEasingFunction:easingFunc forKeyPath:@"backgroundColor"];
                    [proxy setValue:backgroundColor forKey:@"backgroundColor"];
                }
            } completion:nil];
        }
        
        id draggable = [properties objectForKey:@"draggable"];
        
        if ([draggable isKindOfClass:[NSDictionary class]])
        {
            [self animateDraggable:proxy
                           options:draggable
                            easing:easingFunc
                          duration:animationDuration];
        }
        
        [CATransaction commit];
    });
}

- (void)animateDraggable:(TiViewProxy *)parentProxy options:(NSDictionary *)options
                  easing:(AHEasingFunction)easing duration:(double)duration
{
    id draggableProxy = [parentProxy valueForKey:@"draggable"];
    
    if ([draggableProxy isKindOfClass:[TiProxy class]])
    {
        id mappedViews = [draggableProxy valueForKey:@"maps"];
        
        if ([mappedViews isKindOfClass:[NSArray class]])
        {
            [mappedViews enumerateObjectsUsingBlock:^(id map, NSUInteger idx, BOOL *stop) {
                if ([[map objectForKey:@"view"] isKindOfClass:[TiViewProxy class]])
                {
                    NSDictionary *constraints = [map objectForKey:@"constrain"];
                    NSDictionary *constraintX = [constraints objectForKey:@"x"];
                    NSDictionary *constraintY = [constraints objectForKey:@"y"];
                    
                    id xKey = [options objectForKey:@"x"];
                    id yKey = [options objectForKey:@"y"];
                    
                    TiViewProxy *proxy = (TiViewProxy*)[map objectForKey:@"view"];
                    NSNumber *parallaxAmount = [TiUtils numberFromObject:[map objectForKey:@"parallaxAmount"]];
                    NSNumber *left = nil;
                    NSNumber *top = nil;
                    
                    if ([xKey isKindOfClass:[NSString class]])
                    {
                        left = [TiUtils numberFromObject:[constraintX objectForKey:[TiUtils stringValue:xKey]]];
                        left = [NSNumber numberWithFloat:[left floatValue] / [parallaxAmount floatValue]];
                    }
                    else if ([xKey isKindOfClass:[NSNumber class]])
                    {
                        left = [TiUtils numberFromObject:xKey];
                    }
                    
                    if ([yKey isKindOfClass:[NSString class]])
                    {
                        top = [TiUtils numberFromObject:[constraintY objectForKey:[TiUtils stringValue:yKey]]];
                        top = [NSNumber numberWithFloat:[top floatValue] / [parallaxAmount floatValue]];
                    }
                    else if ([yKey isKindOfClass:[NSNumber class]])
                    {
                        top = [TiUtils numberFromObject:yKey];
                    }
                    
                    [proxy.view setOpaque:YES];
                    
                    [UIView animateWithDuration:duration animations:
                     ^{
                         [proxy.view setEasingFunction:easing forKeyPath:@"position"];
                         
                         CGRect oldFrame = [proxy.view frame];
                         CGRect newFrame = CGRectMake([left floatValue],
                                                      [top floatValue],
                                                      oldFrame.size.width,
                                                      oldFrame.size.height);
                         
                         [proxy.view setFrame:newFrame];
                     } completion:^(BOOL finished)
                     {
                         LayoutConstraint *layoutProperties = [proxy layoutProperties];
                         
                         ENSURE_LAYOUT_PROPERTY(left);
                         ENSURE_LAYOUT_PROPERTY(top);
                         
                         object_setInstanceVariable(proxy, "_layoutProperties", &layoutProperties);
                         
                         [proxy.view removeEasingFunctionForKeyPath:@"position"];
                         [proxy.view setOpaque:NO];
                     }];
                }
            }];
        }
    }
}

- (AHEasingFunction)getEasingFunc:(NSNumber *)easingType
{
    switch ([easingType integerValue])
    {
        case EASING_QUAD_IN:
            return QuadraticEaseIn;
            break;
        case EASING_QUAD_OUT:
            return QuadraticEaseOut;
            break;
        case EASING_QUAD_IN_OUT:
            return QuadraticEaseInOut;
            break;
        case EASING_CUBIC_IN:
            return CubicEaseIn;
            break;
        case EASING_CUBIC_OUT:
            return CubicEaseOut;
            break;
        case EASING_CUBIC_IN_OUT:
            return CubicEaseInOut;
            break;
        case EASING_QUART_IN:
            return QuarticEaseIn;
            break;
        case EASING_QUART_OUT:
            return QuarticEaseOut;
            break;
        case EASING_QUART_IN_OUT:
            return QuarticEaseInOut;
            break;
        case EASING_QUINT_IN:
            return QuinticEaseIn;
            break;
        case EASING_QUINT_OUT:
            return QuinticEaseOut;
            break;
        case EASING_QUINT_IN_OUT:
            return QuinticEaseInOut;
            break;
        case EASING_SINE_IN:
            return SineEaseIn;
            break;
        case EASING_SINE_OUT:
            return SineEaseOut;
            break;
        case EASING_SINE_IN_OUT:
            return SineEaseInOut;
            break;
        case EASING_CIRC_IN:
            return CircularEaseIn;
            break;
        case EASING_CIRC_OUT:
            return CircularEaseOut;
            break;
        case EASING_CIRC_IN_OUT:
            return CircularEaseInOut;
            break;
        case EASING_EXP_IN:
            return ExponentialEaseIn;
            break;
        case EASING_EXP_OUT:
            return ExponentialEaseOut;
            break;
        case EASING_EXP_IN_OUT:
            return ExponentialEaseInOut;
            break;
        case EASING_ELASTIC_IN:
            return ElasticEaseIn;
            break;
        case EASING_ELASTIC_OUT:
            return ElasticEaseOut;
            break;
        case EASING_ELASTIC_IN_OUT:
            return ElasticEaseInOut;
            break;
        case EASING_BACK_IN:
            return BackEaseIn;
            break;
        case EASING_BACK_OUT:
            return BackEaseOut;
            break;
        case EASING_BACK_IN_OUT:
            return BackEaseInOut;
            break;
        case EASING_BOUNCE_IN:
            return BounceEaseIn;
            break;
        case EASING_BOUNCE_OUT:
            return BounceEaseOut;
            break;
        case EASING_BOUNCE_IN_OUT:
            return BounceEaseInOut;
            break;
        default:
            return LinearInterpolation;
            break;
    }
}

@end