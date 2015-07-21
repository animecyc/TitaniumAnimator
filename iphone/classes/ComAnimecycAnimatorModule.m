/**
 * Copyright (c) 2015 Seth Benjamin
 * All rights reserved.

 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
#import "ComAnimecycAnimatorModule.h"
#import "TiViewProxy.h"
#import "TiUIView.h"
#import "TiUILabelProxy.h"
#import "TiUILabel.h"
#import "TiUIScrollViewProxy.h"
#import "TiUIScrollView.h"

@implementation ComAnimecycAnimatorModule

#pragma mark - internal

/**
 *  Module GUID
 *
 *  @return GUID of this module
 */
- (id)moduleGUID {
  return @"8d4800af-8a8e-4c54-92f6-add4e25dffcb";
}

/**
 *  Module identifier
 *
 *  @return Indentifier of this module
 */
- (NSString *)moduleId {
  return @"com.animecyc.animator";
}

#pragma mark - public

MAKE_SYSTEM_PROP(LINEAR, EASING_LINEAR);
MAKE_SYSTEM_PROP(QUAD_IN, EASING_QUAD_IN);
MAKE_SYSTEM_PROP(QUAD_OUT, EASING_QUAD_OUT);
MAKE_SYSTEM_PROP(QUAD_IN_OUT, EASING_QUAD_IN_OUT);
MAKE_SYSTEM_PROP(CUBIC_IN, EASING_CUBIC_IN);
MAKE_SYSTEM_PROP(CUBIC_OUT, EASING_CUBIC_OUT);
MAKE_SYSTEM_PROP(CUBIC_IN_OUT, EASING_CUBIC_IN_OUT);
MAKE_SYSTEM_PROP(QUART_IN, EASING_QUART_IN);
MAKE_SYSTEM_PROP(QUART_OUT, EASING_QUART_OUT);
MAKE_SYSTEM_PROP(QUART_IN_OUT, EASING_QUART_IN_OUT);
MAKE_SYSTEM_PROP(QUINT_IN, EASING_QUINT_IN);
MAKE_SYSTEM_PROP(QUINT_OUT, EASING_QUINT_OUT);
MAKE_SYSTEM_PROP(QUINT_IN_OUT, EASING_QUINT_IN_OUT);
MAKE_SYSTEM_PROP(SINE_IN, EASING_SINE_IN);
MAKE_SYSTEM_PROP(SINE_OUT, EASING_SINE_OUT);
MAKE_SYSTEM_PROP(SINE_IN_OUT, EASING_SINE_IN_OUT);
MAKE_SYSTEM_PROP(CIRC_IN, EASING_CIRC_IN);
MAKE_SYSTEM_PROP(CIRC_OUT, EASING_CIRC_OUT);
MAKE_SYSTEM_PROP(CIRC_IN_OUT, EASING_CIRC_IN_OUT);
MAKE_SYSTEM_PROP(EXPO_IN, EASING_EXPO_IN);
MAKE_SYSTEM_PROP(EXPO_OUT, EASING_EXPO_OUT);
MAKE_SYSTEM_PROP(EXPO_IN_OUT, EASING_EXPO_IN_OUT);
MAKE_SYSTEM_PROP(ELASTIC_IN, EASING_ELASTIC_IN);
MAKE_SYSTEM_PROP(ELASTIC_OUT, EASING_ELASTIC_OUT);
MAKE_SYSTEM_PROP(ELASTIC_IN_OUT, EASING_ELASTIC_IN_OUT);
MAKE_SYSTEM_PROP(BACK_IN, EASING_BACK_IN);
MAKE_SYSTEM_PROP(BACK_OUT, EASING_BACK_OUT);
MAKE_SYSTEM_PROP(BACK_IN_OUT, EASING_BACK_IN_OUT);
MAKE_SYSTEM_PROP(BOUNCE_IN, EASING_BOUNCE_IN);
MAKE_SYSTEM_PROP(BOUNCE_OUT, EASING_BOUNCE_OUT);
MAKE_SYSTEM_PROP(BOUNCE_IN_OUT, EASING_BOUNCE_IN_OUT);

/**
 *  Animate a TiViewProxy using supplied arguments; Optionally calls a callback on completion
 *
 *  @param args Method arguments containing at least a TiViewProxy and an NSDictionary
 */
- (void)animate:(id)args {
  if (![NSThread isMainThread]) {
    TiThreadPerformOnMainThread(^{
      [self animate:args];
    }, NO);
    return;
  }

  TiViewProxy *proxy = nil;
  NSDictionary *properties = nil;
  KrollCallback *callback = nil;

  ENSURE_ARG_AT_INDEX(proxy, args, 0, TiViewProxy);
  ENSURE_ARG_AT_INDEX(properties, args, 1, NSDictionary);
  ENSURE_ARG_OR_NIL_AT_INDEX(callback, args, 2, KrollCallback);

  if ([properties count] == 0) {
    NSLog(@"[ERROR] No animation properties supplied, ignoring animation...");
    return;
  } else if (![proxy windowHasOpened] || ![proxy viewAttached]) {
    NSLog(@"[ERROR] Cannot animate a view that is not attached, ignoring animation...");
    return;
  } else if ([proxy layoutProperties] == nil) {
    NSLog(@"[ERROR] Cannot animate a view that lacks an a layout constraint, ignoring animation...");
    return;
  }

  LayoutConstraint *animationConstraint = [proxy layoutProperties];
  NSMutableArray *fromValue = [[NSMutableArray alloc] init];
  NSMutableArray *toValue = [[NSMutableArray alloc] init];

  /* duration */
  CFTimeInterval duration = [TiUtils doubleValue:@"duration" properties:properties def:350.f];

  if (duration > 0) {
    duration /= 1000;
  }

  /* width */
  if ([self dictionary:properties containsKey:@"width"]) {
    TiDimension fromWidth = animationConstraint->width;
    TiDimension toWidth = [TiUtils dimensionValue:@"width" properties:properties];

    if (!TiDimensionIsDip(fromWidth)) {
      fromWidth = TiDimensionDip(proxy.sandboxBounds.size.width);
    }

    if (!TiDimensionIsDip(toWidth)) {
      toWidth = TiDimensionDip(proxy.sandboxBounds.size.width);
    }

    [fromValue addObject:NUMFLOAT(fromWidth.value)];
    [toValue addObject:NUMFLOAT(toWidth.value)];
  } else {
    [fromValue addObject:[NSNull null]];
    [toValue addObject:[NSNull null]];
  }

  /* height */
  if ([self dictionary:properties containsKey:@"height"]) {
    TiDimension fromHeight = animationConstraint->height;
    TiDimension toHeight = [TiUtils dimensionValue:@"height" properties:properties];

    if (!TiDimensionIsDip(fromHeight)) {
      fromHeight = TiDimensionDip(proxy.sandboxBounds.size.height);
    }

    if (!TiDimensionIsDip(toHeight)) {
      toHeight = TiDimensionDip(proxy.sandboxBounds.size.height);
    }

    [fromValue addObject:NUMFLOAT(fromHeight.value)];
    [toValue addObject:NUMFLOAT(toHeight.value)];
  } else {
    [fromValue addObject:[NSNull null]];
    [toValue addObject:[NSNull null]];
  }

  /* top */
  if ([self dictionary:properties containsKey:@"top"]) {
    TiDimension fromTop = animationConstraint->top;
    TiDimension toTop = [TiUtils dimensionValue:@"top" properties:properties];

    [fromValue addObject:NUMFLOAT(fromTop.value)];
    [toValue addObject:NUMFLOAT(toTop.value)];
  } else {
    [fromValue addObject:[NSNull null]];
    [toValue addObject:[NSNull null]];
  }

  /* bottom */
  if ([self dictionary:properties containsKey:@"bottom"]) {
    TiDimension fromBottom = animationConstraint->bottom;
    TiDimension toBottom = [TiUtils dimensionValue:@"bottom" properties:properties];

    [fromValue addObject:NUMFLOAT(fromBottom.value)];
    [toValue addObject:NUMFLOAT(toBottom.value)];
  } else {
    [fromValue addObject:[NSNull null]];
    [toValue addObject:[NSNull null]];
  }

  /* left */
  if ([self dictionary:properties containsKey:@"left"]) {
    TiDimension fromLeft = animationConstraint->left;
    TiDimension toLeft = [TiUtils dimensionValue:@"left" properties:properties];

    [fromValue addObject:NUMFLOAT(fromLeft.value)];
    [toValue addObject:NUMFLOAT(toLeft.value)];
  } else {
    [fromValue addObject:[NSNull null]];
    [toValue addObject:[NSNull null]];
  }

  /* right */
  if ([self dictionary:properties containsKey:@"right"]) {
    TiDimension fromRight = animationConstraint->right;
    TiDimension toRight = [TiUtils dimensionValue:@"right" properties:properties];

    [fromValue addObject:NUMFLOAT(fromRight.value)];
    [toValue addObject:NUMFLOAT(toRight.value)];
  } else {
    [fromValue addObject:[NSNull null]];
    [toValue addObject:[NSNull null]];
  }

  /* rotate */
  if ([self dictionary:properties containsKey:@"rotate"]) {
    CGAffineTransform currentTransform = [proxy.view transform];
    double fromRotate = radiansToDegrees(atan2(currentTransform.b, currentTransform.a));
    double toRotate = [TiUtils doubleValue:@"rotate" properties:properties def:0];

    [fromValue addObject:NUMDOUBLE(fromRotate)];
    [toValue addObject:NUMDOUBLE(toRotate)];
  } else {
    [fromValue addObject:[NSNull null]];
    [toValue addObject:[NSNull null]];
  }

  /* opacity */
  if ([self dictionary:properties containsKey:@"opacity"]) {
    double fromOpacity = [proxy.view alpha];
    double toOpacity = [TiUtils doubleValue:@"opacity" properties:properties def:1.f];

    [fromValue addObject:NUMDOUBLE(fromOpacity)];
    [toValue addObject:NUMDOUBLE(toOpacity)];
  } else {
    [fromValue addObject:[NSNull null]];
    [toValue addObject:[NSNull null]];
  }

  /* backgroundColor */
  if ([self dictionary:properties containsKey:@"backgroundColor"]) {
    // Default background color is nil, we are making an assumption that the background appearance is transparent, not
    // sure what else to do for detecting initial backgroundColor...
    UIColor *fromBackgroundColor =
        [proxy.view backgroundColor] != nil ? [proxy.view backgroundColor] : [UIColor clearColor];
    UIColor *toBackgroundColor = [[TiUtils colorValue:@"backgroundColor" properties:properties] color];

    [fromValue addObject:fromBackgroundColor];
    [toValue addObject:toBackgroundColor];
  } else {
    [fromValue addObject:[NSNull null]];
    [toValue addObject:[NSNull null]];
  }

  /* color */
  if ([proxy isKindOfClass:[TiUILabelProxy class]] && [self dictionary:properties containsKey:@"color"]) {
    TiUILabelProxy *labelProxy = (TiUILabelProxy *)proxy;
    TiUILabel *labelView = (TiUILabel *)[labelProxy view];
    UIColor *fromColor = [labelView.label textColor];
    UIColor *toColor = [[TiUtils colorValue:@"color" properties:properties] color];

    [fromValue addObject:fromColor];
    [toValue addObject:toColor];
  } else {
    [fromValue addObject:[NSNull null]];
    [toValue addObject:[NSNull null]];
  }

  MMTweenAnimation *animation = [MMTweenAnimation animation];
  TiAnimatorEasingGroup easingGroup = [self easingGroupForAnimationProperties:properties];

  [animation setDuration:duration];
  [animation setFromValue:[fromValue copy]];
  [animation setToValue:[toValue copy]];
  [animation setFunctionType:easingGroup.function];
  [animation setEasingType:easingGroup.type];
  [animation setRemovedOnCompletion:YES];

  [animation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
    if (finished) {
      NSMutableDictionary *newProxyValues = [NSMutableDictionary dictionaryWithDictionary:properties];

      // We should probably filter the proxy values being set here some more but for the time being assume the user
      // will only be animating properties that are supported by the module...
      [newProxyValues removeObjectForKey:@"duration"];
      [newProxyValues removeObjectForKey:@"easing"];

      [proxy setValuesForKeysWithDictionary:[newProxyValues copy]];

      // Ensure we have the correct radians if we have rotated the view...
      if (toValue[6] != (id)[NSNull null]) {
        double radians = degreesToRadians([toValue[6] doubleValue]);
        CGAffineTransform rotation = CGAffineTransformRotate(CGAffineTransformIdentity, radians);

        [proxy.view setTransform:rotation];
      }

      if (callback != nil) {
        id<TiEvaluator> evaluator = [proxy pageContext] == nil ? [self executionContext] : [proxy pageContext];

        // The callback *MUST* be called on the same thread as the proxy being animated otherwise a lot of things will
        // fail or otherwise have unexpected ramifications and we wouldnt want that...
        [[evaluator krollContext] invokeBlockOnThread:^{
          [callback call:nil thisObject:nil];
        }];
      }
    }
  }];

  [animation
      setAnimationBlock:^(double time, double duration, NSArray *value, id target_, MMTweenAnimation *animation) {
        // Relayouts pretty expensive depending on the view hierarchy, we need an assurance that we did in fact have a
        // change that requires a relayout as it will affect more than just animating view if their are non-absolute or
        // auto-sizing parents...
        BOOL needsRelayout = NO;

        /* width */
        if (value[0] != (id)[NSNull null]) {
          animationConstraint->width = TiDimensionDip([value[0] floatValue]);
          needsRelayout = YES;
        }

        /* height */
        if (value[1] != (id)[NSNull null]) {
          animationConstraint->height = TiDimensionDip([value[1] floatValue]);
          needsRelayout = YES;
        }

        /* top */
        if (value[2] != (id)[NSNull null]) {
          animationConstraint->top = TiDimensionDip([value[2] floatValue]);
          needsRelayout = YES;
        }

        /* bottom */
        if (value[3] != (id)[NSNull null]) {
          animationConstraint->bottom = TiDimensionDip([value[3] floatValue]);
          needsRelayout = YES;
        }

        /* left */
        if (value[4] != (id)[NSNull null]) {
          animationConstraint->left = TiDimensionDip([value[4] floatValue]);
          needsRelayout = YES;
        }

        /* right */
        if (value[5] != (id)[NSNull null]) {
          animationConstraint->right = TiDimensionDip([value[5] floatValue]);
          needsRelayout = YES;
        }

        /* rotate */
        if (value[6] != (id)[NSNull null]) {
          // All rotations happen against an identity transformation, this may cause issues with other transformations
          // applied to view that this module does not know about, this probably should be refactored out...
          double radians = degreesToRadians([value[6] doubleValue]);
          CGAffineTransform rotation = CGAffineTransformRotate(CGAffineTransformIdentity, radians);

          [proxy.view setTransform:rotation];
        }

        /* opacity */
        if (value[7] != (id)[NSNull null]) {
          [proxy.view setAlpha:[value[7] floatValue]];
        }

        /* backgroundColor */
        if (value[8] != (id)[NSNull null]) {
          [proxy.view setBackgroundColor:value[8]];
        }

        /* color */
        if (value[9] != (id)[NSNull null]) {
          TiUILabelProxy *labelProxy = (TiUILabelProxy *)proxy;
          TiUILabel *labelView = (TiUILabel *)[labelProxy view];

          [labelView.label setTextColor:value[9]];
        }

        if (needsRelayout) {
          [self recursivelyRelayoutProxy:proxy];
        }
      }];

  [[proxy view] pop_addAnimation:animation forKey:@"animator"];
}

#pragma mark - utility

/**
 *  Relayout a TiViewProxy ensure that its parent TiViewProxys relayout along with it. Only parents whos layouts are
 *  non-absolute or have auto-sizing
 *
 *  @param proxy Proxy with ancestors to refresh
 */
- (void)recursivelyRelayoutProxy:(TiViewProxy *)proxy {
  TiViewProxy *parent = proxy.parent;

  [self relayoutProxy:proxy];

  if (parent != nil) {
    LayoutConstraint *parentConstraint = [parent layoutProperties];
    BOOL isAbsolute = TiLayoutRuleIsAbsolute(parentConstraint->layoutStyle);
    BOOL isAutoSizing =
        TiDimensionIsAutoSize(parentConstraint->width) || TiDimensionIsAutoSize(parentConstraint->height);

    if ([parent isKindOfClass:[TiUIScrollViewProxy class]]) {
      TiUIScrollViewProxy *scrollViewProxy = (TiUIScrollViewProxy *)parent;
      TiUIScrollView *scrollView = (TiUIScrollView *)[scrollViewProxy view];

      // This will cause the TiUIScrollViewProxy to be places into the layout queue which, while not expensive, is slow.
      // I can't think of where this would cause issues but for the time being we'll rely on Titanium to handle our
      // sizing needs...
      [scrollView setNeedsHandleContentSizeIfAutosizing];
    }

    // There is no point in forcing a relayout of views that are fixed in size, until issues arise from block this
    // operation this will stay to keep our animations nimble...
    if (!isAbsolute || isAutoSizing) {
      [self recursivelyRelayoutProxy:parent];
    }
  }
}

/**
 *  Relayout a supplied proxy using a derivitive of TiViewProxy's relayout method
 *
 *  @param proxy TiViewProxy to relayout
 */
- (void)relayoutProxy:(TiViewProxy *)proxy {
  TiViewProxy *parent = proxy.parent;
  UIView *parentView = [parent parentViewForChild:proxy];
  CGRect sandboxBounds = [proxy sandboxBounds];
  CGSize referenceSize = parentView != nil ? [parentView bounds].size : sandboxBounds.size;

  // Use the current sizeCache of the supplied TiViewProxy to ensure we have the right origin otherwise our animations
  // will appear to 'pop' and 'pin' to the top of its parent...
  CGRect sizeCache = [[proxy valueForKey:@"sizeCache"] CGRectValue];
  LayoutConstraint *layoutProperties = [proxy layoutProperties];

  // We should really be pulling in the autoresize cache from the supplied proxy but for the sake of simplicity we are
  // just going to assume we aren't using any autoresizing, this will probably only cause issues when animating custom
  // views not supplied by Titanium...
  UIViewAutoresizing autoresizeCache = UIViewAutoresizingNone;

  if (parent != nil && (!TiLayoutRuleIsAbsolute([parent layoutProperties]->layoutStyle))) {
    sizeCache.size =
        SizeConstraintViewWithSizeAddingResizing(layoutProperties, proxy, sandboxBounds.size, &autoresizeCache);
  } else {
    sizeCache.size = SizeConstraintViewWithSizeAddingResizing(layoutProperties, proxy, referenceSize, &autoresizeCache);
  }

  CGPoint positionCache = PositionConstraintGivenSizeBoundsAddingResizing(
      layoutProperties, proxy, sizeCache.size, [[proxy.view layer] anchorPoint], referenceSize, sandboxBounds.size,
      &autoresizeCache);

  positionCache.x += sizeCache.origin.x + sandboxBounds.origin.x;
  positionCache.y += sizeCache.origin.y + sandboxBounds.origin.y;

  [proxy.view setAutoresizingMask:autoresizeCache];
  [proxy.view setCenter:positionCache];
  [proxy.view setBounds:sizeCache];

  // Update our size and position caches for subsequent interpolations, this fixes edge cases where the size cache gets
  // updated by an outside process during an animation; That being said this may interfere with custom modules that pull
  // from the size and position caches...
  [proxy setValue:[NSValue valueWithCGRect:sizeCache] forKey:@"sizeCache"];
  [proxy setValue:[NSValue valueWithCGPoint:positionCache] forKey:@"positionCache"];
}

/**
 *  Get an animation easing group for a supplied module system property
 *
 *  @param easing Titanium system property
 *
 *  @return Resultant easing group
 */
- (TiAnimatorEasingGroup)easingGroupForAnimationProperties:(NSDictionary *)properties {
  NSInteger easingProp = [[TiUtils numberFromObject:[properties objectForKey:@"easing"]] integerValue];

  switch (easingProp) {
    case EASING_LINEAR:
      return LINEAR;
    case EASING_QUAD_IN:
      return QUAD_IN;
    case EASING_QUAD_OUT:
      return QUAD_OUT;
    case EASING_QUAD_IN_OUT:
      return QUAD_IN_OUT;
    case EASING_CUBIC_IN:
      return CUBIC_IN;
    case EASING_CUBIC_OUT:
      return CUBIC_OUT;
    case EASING_CUBIC_IN_OUT:
      return CUBIC_IN_OUT;
    case EASING_QUART_IN:
      return QUART_IN;
    case EASING_QUART_OUT:
      return QUART_OUT;
    case EASING_QUART_IN_OUT:
      return QUINT_IN_OUT;
    case EASING_QUINT_IN:
      return QUINT_IN;
    case EASING_QUINT_OUT:
      return QUINT_OUT;
    case EASING_QUINT_IN_OUT:
      return QUINT_IN_OUT;
    case EASING_SINE_IN:
      return SINE_IN;
    case EASING_SINE_OUT:
      return SINE_OUT;
    case EASING_SINE_IN_OUT:
      return SINE_IN_OUT;
    case EASING_CIRC_IN:
      return CIRC_IN;
    case EASING_CIRC_OUT:
      return CIRC_OUT;
    case EASING_CIRC_IN_OUT:
      return CIRC_IN_OUT;
    case EASING_EXPO_IN:
      return EXPO_IN;
    case EASING_EXPO_OUT:
      return EXPO_OUT;
    case EASING_EXPO_IN_OUT:
      return EXPO_IN_OUT;
    case EASING_ELASTIC_IN:
      return ELASTIC_IN;
    case EASING_ELASTIC_OUT:
      return ELASTIC_OUT;
    case EASING_ELASTIC_IN_OUT:
      return ELASTIC_IN_OUT;
    case EASING_BACK_IN:
      return BACK_IN;
    case EASING_BACK_OUT:
      return BACK_OUT;
    case EASING_BACK_IN_OUT:
      return BACK_IN_OUT;
    case EASING_BOUNCE_IN:
      return BOUNCE_IN;
    case EASING_BOUNCE_OUT:
      return BOUNCE_OUT;
    case EASING_BOUNCE_IN_OUT:
      return BOUNCE_IN_OUT;
    default:
      return LINEAR;
  }
}

/**
 *  Check to see if a supplied NSDictionary contains a key
 *
 *  @param dictionary NSDictionary to check against
 *  @param key        Key to check for
 *
 *  @return Flag denoting key existance
 */
- (BOOL)dictionary:(NSDictionary *)dictionary containsKey:(NSString *)key {
  return [dictionary objectForKey:key] != nil;
}

@end
