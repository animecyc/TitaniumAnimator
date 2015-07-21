/**
 * Copyright (c) 2015 Seth Benjamin
 * All rights reserved.

 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
#import "TiModule.h"
#import "MMTweenAnimation.h"

struct TiAnimatorEasingGroup {
  MMTweenFunctionType function;
  MMTweenEasingType type;
};

typedef struct TiAnimatorEasingGroup TiAnimatorEasingGroup;

typedef NS_ENUM(NSInteger, TiAnimatorEasing) {
  EASING_LINEAR = 0,
  EASING_QUAD_IN,
  EASING_QUAD_OUT,
  EASING_QUAD_IN_OUT,
  EASING_CUBIC_IN,
  EASING_CUBIC_OUT,
  EASING_CUBIC_IN_OUT,
  EASING_QUART_IN,
  EASING_QUART_OUT,
  EASING_QUART_IN_OUT,
  EASING_QUINT_IN,
  EASING_QUINT_OUT,
  EASING_QUINT_IN_OUT,
  EASING_SINE_IN,
  EASING_SINE_OUT,
  EASING_SINE_IN_OUT,
  EASING_CIRC_IN,
  EASING_CIRC_OUT,
  EASING_CIRC_IN_OUT,
  EASING_EXPO_IN,
  EASING_EXPO_OUT,
  EASING_EXPO_IN_OUT,
  EASING_ELASTIC_IN,
  EASING_ELASTIC_OUT,
  EASING_ELASTIC_IN_OUT,
  EASING_BACK_IN,
  EASING_BACK_OUT,
  EASING_BACK_IN_OUT,
  EASING_BOUNCE_IN,
  EASING_BOUNCE_OUT,
  EASING_BOUNCE_IN_OUT
};

const struct TiAnimatorEasingGroup LINEAR = {MMTweenFunctionLinear, MMTweenEasingIn};
const struct TiAnimatorEasingGroup QUAD_IN = {MMTweenFunctionQuad, MMTweenEasingIn};
const struct TiAnimatorEasingGroup QUAD_OUT = {MMTweenFunctionQuad, MMTweenEasingOut};
const struct TiAnimatorEasingGroup QUAD_IN_OUT = {MMTweenFunctionQuad, MMTweenEasingInOut};
const struct TiAnimatorEasingGroup CUBIC_IN = {MMTweenFunctionCubic, MMTweenEasingIn};
const struct TiAnimatorEasingGroup CUBIC_OUT = {MMTweenFunctionCubic, MMTweenEasingOut};
const struct TiAnimatorEasingGroup CUBIC_IN_OUT = {MMTweenFunctionCubic, MMTweenEasingInOut};
const struct TiAnimatorEasingGroup QUART_IN = {MMTweenFunctionQuart, MMTweenEasingIn};
const struct TiAnimatorEasingGroup QUART_OUT = {MMTweenFunctionQuart, MMTweenEasingOut};
const struct TiAnimatorEasingGroup QUART_IN_OUT = {MMTweenFunctionQuart, MMTweenEasingInOut};
const struct TiAnimatorEasingGroup QUINT_IN = {MMTweenFunctionQuint, MMTweenEasingIn};
const struct TiAnimatorEasingGroup QUINT_OUT = {MMTweenFunctionQuint, MMTweenEasingOut};
const struct TiAnimatorEasingGroup QUINT_IN_OUT = {MMTweenFunctionQuint, MMTweenEasingInOut};
const struct TiAnimatorEasingGroup SINE_IN = {MMTweenFunctionSine, MMTweenEasingIn};
const struct TiAnimatorEasingGroup SINE_OUT = {MMTweenFunctionSine, MMTweenEasingOut};
const struct TiAnimatorEasingGroup SINE_IN_OUT = {MMTweenFunctionSine, MMTweenEasingInOut};
const struct TiAnimatorEasingGroup CIRC_IN = {MMTweenFunctionCirc, MMTweenEasingIn};
const struct TiAnimatorEasingGroup CIRC_OUT = {MMTweenFunctionCirc, MMTweenEasingOut};
const struct TiAnimatorEasingGroup CIRC_IN_OUT = {MMTweenFunctionCirc, MMTweenEasingInOut};
const struct TiAnimatorEasingGroup EXPO_IN = {MMTweenFunctionExpo, MMTweenEasingIn};
const struct TiAnimatorEasingGroup EXPO_OUT = {MMTweenFunctionExpo, MMTweenEasingOut};
const struct TiAnimatorEasingGroup EXPO_IN_OUT = {MMTweenFunctionExpo, MMTweenEasingInOut};
const struct TiAnimatorEasingGroup ELASTIC_IN = {MMTweenFunctionElastic, MMTweenEasingIn};
const struct TiAnimatorEasingGroup ELASTIC_OUT = {MMTweenFunctionElastic, MMTweenEasingOut};
const struct TiAnimatorEasingGroup ELASTIC_IN_OUT = {MMTweenFunctionElastic, MMTweenEasingInOut};
const struct TiAnimatorEasingGroup BACK_IN = {MMTweenFunctionBack, MMTweenEasingIn};
const struct TiAnimatorEasingGroup BACK_OUT = {MMTweenFunctionBack, MMTweenEasingOut};
const struct TiAnimatorEasingGroup BACK_IN_OUT = {MMTweenFunctionBack, MMTweenEasingInOut};
const struct TiAnimatorEasingGroup BOUNCE_IN = {MMTweenFunctionBounce, MMTweenEasingIn};
const struct TiAnimatorEasingGroup BOUNCE_OUT = {MMTweenFunctionBounce, MMTweenEasingOut};
const struct TiAnimatorEasingGroup BOUNCE_IN_OUT = {MMTweenFunctionBounce, MMTweenEasingInOut};

@interface ComAnimecycAnimatorModule : TiModule

@end
