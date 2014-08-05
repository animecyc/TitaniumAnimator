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
#import <objc/runtime.h>
#import "UIView+EasingFunctions.h"
#import "CAKeyframeAnimation+AHEasing.h"
#import "TiUtils.h"
#import "TiViewProxy.h"
#import "TiUIScrollView.h"
#import "TiUIScrollViewProxy.h"
#import "KrollCallback.h"
#import "ComAnimecycAnimatorModule.h"

NS_ENUM(NSInteger, AnimationEasingType)
{
    EASING_LINEAR         = 0,
    EASING_QUAD_IN        = 1,
    EASING_QUAD_OUT       = 2,
    EASING_QUAD_IN_OUT    = 3,
    EASING_CUBIC_IN       = 4,
    EASING_CUBIC_OUT      = 5,
    EASING_CUBIC_IN_OUT   = 6,
    EASING_QUART_IN       = 7,
    EASING_QUART_OUT      = 8,
    EASING_QUART_IN_OUT   = 9,
    EASING_QUINT_IN       = 10,
    EASING_QUINT_OUT      = 11,
    EASING_QUINT_IN_OUT   = 12,
    EASING_SINE_IN        = 13,
    EASING_SINE_OUT       = 14,
    EASING_SINE_IN_OUT    = 15,
    EASING_CIRC_IN        = 16,
    EASING_CIRC_OUT       = 17,
    EASING_CIRC_IN_OUT    = 18,
    EASING_EXP_IN         = 19,
    EASING_EXP_OUT        = 20,
    EASING_EXP_IN_OUT     = 21,
    EASING_ELASTIC_IN     = 22,
    EASING_ELASTIC_OUT    = 23,
    EASING_ELASTIC_IN_OUT = 24,
    EASING_BACK_IN        = 25,
    EASING_BACK_OUT       = 26,
    EASING_BACK_IN_OUT    = 27,
    EASING_BOUNCE_IN      = 28,
    EASING_BOUNCE_OUT     = 29,
    EASING_BOUNCE_IN_OUT  = 30
};

@interface AnimationFactory : NSObject

typedef void (^ CallbackBlock)(void);

#define ENSURE_LAYOUT_PROPERTY(prop) {\
    if (prop && layoutProperties) {\
        layoutProperties->prop = TiDimensionFromObject(prop);\
    }\
}

- (void)animateUsingProxy:(TiViewProxy*)proxy andProperties:(NSDictionary*)properties completed:(KrollCallback*)completed;

@end