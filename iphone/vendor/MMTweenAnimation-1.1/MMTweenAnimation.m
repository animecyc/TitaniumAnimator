//
//  MMTweenAnimation.h
//  MMTweenAnimation
//
//  Created by Ralph Li on 4/4/15.
//  Copyright (c) 2015 LJC. All rights reserved.
//
//  Updates by Seth Benjamin
//  Copyright (c) 2015 Seth Benjamin. All rights reserved.

#import "MMTweenAnimation.h"
#import "POPCGUtils.h"

@interface MMTweenAnimation ()

@property(nonatomic, copy) MMTweenFunctionBlock functionBlock;

@end

@implementation MMTweenAnimation

+ (instancetype)animation {
  POPCustomAnimationBlock animationBlock = ^BOOL(id target, POPCustomAnimation *animation) {
    MMTweenAnimation *tween = (MMTweenAnimation *)animation;

    MMTweenFunctionBlock func = tween.functionBlock;
    double time = (tween.currentTime - tween.beginTime);
    double duration = tween.duration;

    NSAssert(tween.fromValue.count == tween.toValue.count, @"fromValue.count != toValue.count");

    if (time < duration) {
      NSMutableArray *value = [@[] mutableCopy];

      for (int i = 0; i < tween.fromValue.count; ++i) {
        id fromValue = tween.fromValue[i];
        id toValue = tween.toValue[i];

        if ([fromValue isKindOfClass:[NSNumber class]]) {
          double from = ((NSNumber *)fromValue).doubleValue;
          double to = ((NSNumber *)toValue).doubleValue;

          [value addObject:@(func(time, from, to - from, duration))];
        } else if ([fromValue isKindOfClass:[UIColor class]]) {
          struct CGColor *fromColor = POPCGColorWithColor(fromValue);
          struct CGColor *toColor = POPCGColorWithColor(toValue);
          CGFloat fromComponents[4];
          CGFloat toComponents[4];

          POPCGColorGetRGBAComponents(fromColor, fromComponents);
          POPCGColorGetRGBAComponents(toColor, toComponents);

          CGFloat newComponents[4];

          for (size_t idx = 0; idx < 4; idx++) {
            double from = fromComponents[idx];
            double to = toComponents[idx];

            newComponents[idx] = func(time, from, to - from, duration);
          }

          [value addObject:POPUIColorRGBACreate(newComponents)];
        } else {
          [value addObject:toValue];
        }
      }

      if (tween.animationBlock) {
        tween.animationBlock(time, duration, value, target, tween);
      }

      return YES;
    }

    return NO;
  };

  MMTweenAnimation *animation = [super animationWithBlock:animationBlock];

  [animation setDuration:0.35];
  [animation setFunctionType:MMTweenFunctionQuad];
  [animation setEasingType:MMTweenEasingOut];

  return animation;
}

- (void)setFunctionType:(MMTweenFunctionType)functionType {
  _functionType = functionType;

  MMTweenFunction *function = [MMTweenFunction sharedInstance];

  self.functionBlock = function.functionTable[functionType][self.easingType];
}

- (void)setEasingType:(MMTweenEasingType)easingType {
  _easingType = easingType;

  MMTweenFunction *function = [MMTweenFunction sharedInstance];

  self.functionBlock = function.functionTable[self.functionType][easingType];
}

@end
