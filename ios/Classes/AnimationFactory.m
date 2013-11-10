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
#import "KrollCallback.h"
#import "UIView+EasingFunctions.h"
#import "CAKeyframeAnimation+AHEasing.h"

@implementation AnimationFactory

typedef void (^ CallbackBlock)(void);

#define ENSURE_LAYOUT_PROPERTY(prop)\
{\
if (prop && layoutProperties)\
{\
layoutProperties->prop = TiDimensionFromObject(prop);\
}\
}

- (void)animateUsingProxy:(TiViewProxy*)proxy andProperties:(NSDictionary*)properties completed:(KrollCallback*)completed
{
    NSNumber* left = [properties objectForKey:@"left"];
    NSNumber* right = [properties objectForKey:@"right"];
    NSNumber* top = [properties objectForKey:@"top"];
    NSNumber* bottom = [properties objectForKey:@"bottom"];
    NSNumber* width = [properties objectForKey:@"width"];
    NSNumber* height = [properties objectForKey:@"height"];
    NSNumber* opacity = [properties objectForKey:@"opacity"];
    NSNumber* rotate = [properties objectForKey:@"rotate"];
    TiProxy* transform = [properties objectForKey:@"transform"];
    TiColor* color = [TiUtils colorValue:[properties objectForKey:@"color"]];
    TiColor* backgroundColor = [TiUtils colorValue:[properties objectForKey:@"backgroundColor"]];
    NSNumber* duration = [properties objectForKey:@"duration"];
    NSNumber* easing = [properties objectForKey:@"easing"];
    NSNumber* animateSiblings = [properties objectForKey:@"siblings"];

    if (duration == nil)
    {
        duration = [NSNumber numberWithInteger:1000];
    }

    if (easing == nil)
    {
        easing = [NSNumber numberWithInteger:EASING_LINEAR];
    }

    double duration_ = [duration doubleValue] / 1000;
    AHEasingFunction easingFunc = [self getEasingFunc:easing];

    if (rotate)
    {
        double rotateFrom = degreesToRadians([[proxy valueForKey:@"__rotation"] floatValue]);
        double rotateTo = rotateFrom + degreesToRadians([rotate floatValue]);

        [CATransaction begin];
        [CATransaction setValue:[NSNumber numberWithDouble:duration_] forKey:kCATransactionAnimationDuration];

        CAKeyframeAnimation* rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"
                                                                                function:easingFunc
                                                                               fromValue:rotateFrom
                                                                                 toValue:rotateTo];

        [proxy.view.layer addAnimation:rotateAnimation forKey:@"rotation"];

        [CATransaction commit];

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

    // If the label being animated has an appropriate CATextLayer
    // attached to it and responds to the setTextColor the below
    // should animate as expected. At this time there is no support
    // for any of the easing functions

    if (color)
    {
        [CATransaction begin];
        [CATransaction setValue:[NSNumber numberWithDouble:duration_] forKey:kCATransactionAnimationDuration];

        [proxy setValue:color forKey:@"color"];

        [CATransaction commit];
    }

    if (transform || top || left || bottom || right || width || height || opacity || backgroundColor || color)
    {
        [UIView animateWithDuration:duration_ animations:^{
            if (transform)
            {
                [proxy.view setEasingFunction:easingFunc forKeyPath:@"transform"];
                [proxy.view setTransform_:transform];
            }

            if (top || left || bottom || right || width || height)
            {
                [proxy.view setEasingFunction:easingFunc forKeyPath:@"frame"];

                LayoutConstraint* layoutProperties = [proxy layoutProperties];

                ENSURE_LAYOUT_PROPERTY(left);
                ENSURE_LAYOUT_PROPERTY(right);
                ENSURE_LAYOUT_PROPERTY(top);
                ENSURE_LAYOUT_PROPERTY(bottom);
                ENSURE_LAYOUT_PROPERTY(width);
                ENSURE_LAYOUT_PROPERTY(height);

                if (animateSiblings)
                {
                    [proxy.parent.children enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                        TiViewProxy* sibling = (TiViewProxy*)obj;

                        if (! [proxy isEqual:sibling])
                        {
                            [sibling.view setEasingFunction:easingFunc forKeyPath:@"position"];
                        }
                    }];

                    [proxy.parent layoutChildren:NO];
                }
                else
                {
                    [proxy reposition];
                }
            }

            if (opacity)
            {
                [proxy.view setEasingFunction:easingFunc forKeyPath:@"alpha"];
                [proxy setValue:opacity forKey:@"opacity"];
            }

            if (backgroundColor)
            {
                [proxy.view setEasingFunction:easingFunc forKeyPath:@"backgroundColor"];
                [proxy setValue:backgroundColor forKey:@"backgroundColor"];
            }
        }];
    }

    // Mixing the explicit CATransaction and the implcit UIView animation
    // causes issues with their respective completion block; To ensure the
    // callback is called everytime regardless of animation properties
    // we'll just delay the execution for `duration_` seconds

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration_ * NSEC_PER_SEC), dispatch_get_main_queue(), ^(void){
        if (top || left || bottom || right || width || height)
        {
            [proxy.view removeEasingFunctionForKeyPath:@"frame"];
        }

        if (transform)
        {
            [proxy.view removeEasingFunctionForKeyPath:@"transform"];
        }

        if (opacity)
        {
            [proxy.view removeEasingFunctionForKeyPath:@"alpha"];
        }

        if (backgroundColor)
        {
            [proxy.view removeEasingFunctionForKeyPath:@"backgroundColor"];
        }

        if (completed)
        {
            [proxy _fireEventToListener:@"animated" withObject:nil listener:completed thisObject:proxy];
        }
    });

    if ([[properties objectForKey:@"draggable"] isKindOfClass:[NSDictionary class]])
    {
        [self animateDraggable:proxy
                       options:[properties objectForKey:@"draggable"]
                        easing:[self getEasingFunc:easing]
                      duration:duration_];
    }
}

- (void)animateDraggable:(TiViewProxy*)parentProxy options:(NSDictionary*)options easing:(AHEasingFunction)easing duration:(double)duration
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
                    NSDictionary* constraints = [map objectForKey:@"constrain"];
                    NSDictionary* constraintX = [constraints objectForKey:@"x"];
                    NSDictionary* constraintY = [constraints objectForKey:@"y"];

                    id xKey = [options objectForKey:@"x"];
                    id yKey = [options objectForKey:@"y"];

                    TiViewProxy* proxy = (TiViewProxy*)[map objectForKey:@"view"];
                    NSNumber* parallaxAmount = [TiUtils numberFromObject:[map objectForKey:@"parallaxAmount"]];
                    NSNumber* left;
                    NSNumber* top;

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
                        top = [NSNumber numberWithFloat:[left floatValue] / [parallaxAmount floatValue]];
                    }
                    else if ([yKey isKindOfClass:[NSNumber class]])
                    {
                        top = [TiUtils numberFromObject:yKey];
                    }

                    [UIView animateWithDuration:duration
                                     animations:^{
                                         [proxy.view setEasingFunction:easing forKeyPath:@"position"];

                                         LayoutConstraint* layoutProperties = [proxy layoutProperties];

                                         ENSURE_LAYOUT_PROPERTY(left);
                                         ENSURE_LAYOUT_PROPERTY(top);

                                         [proxy reposition];
                                     }
                                     completion:^(BOOL finished) {
                                         [proxy.view removeEasingFunctionForKeyPath:@"position"];
                                     }];
                }
            }];
        }
    }
}

- (AHEasingFunction)getEasingFunc:(NSNumber*)easingType
{
    switch ([easingType integerValue]) {
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