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
#import "ComAnimecycAnimatorModule.h"

@implementation ComAnimecycAnimatorModule

#pragma mark Internal

-(id)moduleGUID
{
	return @"9121C973-0D25-468F-B2CD-5E93DA983AC8";
}

-(NSString*)moduleId
{
	return @"com.animecyc.animator";
}

- (void)animate:(id)args
{
    TiViewProxy* proxy = nil;
    NSDictionary* properties = nil;
    KrollCallback* callback = nil;

    ENSURE_ARG_AT_INDEX(proxy, args, 0, TiViewProxy);
    ENSURE_ARG_OR_NIL_AT_INDEX(properties, args, 1, NSDictionary);
    ENSURE_ARG_OR_NIL_AT_INDEX(callback, args, 2, KrollCallback);
    
    NSNumber *delay = [TiUtils numberFromObject:[properties objectForKey:@"delay"]];
    
    delay = (delay != nil ? delay : NUMINT(0));
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, ([delay doubleValue] / 1000) * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        AnimationFactory* animation = [[[AnimationFactory alloc] init] autorelease];
        
        [animation animateUsingProxy:proxy andProperties:properties completed:callback];
    });
}

- (void)animationTransaction:(id)transaction
{
    ENSURE_SINGLE_ARG(transaction, KrollCallback);
    
    if (transaction != nil)
    {
        [CATransaction begin];
        [transaction call:nil thisObject:nil];
        [CATransaction commit];
    }
}

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
MAKE_SYSTEM_PROP(EXP_IN, EASING_EXP_IN);
MAKE_SYSTEM_PROP(EXP_OUT, EASING_EXP_OUT);
MAKE_SYSTEM_PROP(EXP_IN_OUT, EASING_EXP_IN_OUT);
MAKE_SYSTEM_PROP(ELASTIC_IN, EASING_ELASTIC_IN);
MAKE_SYSTEM_PROP(ELASTIC_OUT, EASING_ELASTIC_OUT);
MAKE_SYSTEM_PROP(ELASTIC_IN_OUT, EASING_ELASTIC_IN_OUT);
MAKE_SYSTEM_PROP(BACK_IN, EASING_BACK_IN);
MAKE_SYSTEM_PROP(BACK_OUT, EASING_BACK_OUT);
MAKE_SYSTEM_PROP(BACK_IN_OUT, EASING_BACK_IN_OUT);
MAKE_SYSTEM_PROP(BOUNCE_IN, EASING_BOUNCE_IN);
MAKE_SYSTEM_PROP(BOUNCE_OUT, EASING_BOUNCE_OUT);
MAKE_SYSTEM_PROP(BOUNCE_IN_OUT, EASING_BOUNCE_IN_OUT);

@end