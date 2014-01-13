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
package com.animecyc.animator;

import java.util.HashMap;
import java.util.Iterator;
import java.util.Map.Entry;
import java.util.UUID;

import org.appcelerator.kroll.KrollDict;
import org.appcelerator.kroll.KrollFunction;
import org.appcelerator.kroll.KrollModule;
import org.appcelerator.kroll.annotations.Kroll;
import org.appcelerator.titanium.TiApplication;
import org.appcelerator.titanium.TiC;
import org.appcelerator.titanium.TiDimension;
import org.appcelerator.titanium.proxy.TiViewProxy;
import org.appcelerator.titanium.util.TiConvert;
import org.appcelerator.titanium.view.TiCompositeLayout;

import android.app.Activity;
import android.graphics.Color;
import android.view.View;
import aurelienribon.tweenengine.BaseTween;
import aurelienribon.tweenengine.Timeline;
import aurelienribon.tweenengine.Tween;
import aurelienribon.tweenengine.TweenCallback;
import aurelienribon.tweenengine.TweenEquation;
import aurelienribon.tweenengine.TweenManager;
import aurelienribon.tweenengine.equations.Back;
import aurelienribon.tweenengine.equations.Bounce;
import aurelienribon.tweenengine.equations.Circ;
import aurelienribon.tweenengine.equations.Cubic;
import aurelienribon.tweenengine.equations.Elastic;
import aurelienribon.tweenengine.equations.Expo;
import aurelienribon.tweenengine.equations.Linear;
import aurelienribon.tweenengine.equations.Quad;
import aurelienribon.tweenengine.equations.Quart;
import aurelienribon.tweenengine.equations.Quint;
import aurelienribon.tweenengine.equations.Sine;

@Kroll.module(name="Animator", id="com.animecyc.animator")
public class AnimatorModule extends KrollModule
{
	/**
	 * Easing Equation -- Linear
	 */
	@Kroll.constant public static final int LINEAR = 0;

	/**
	 * Easing Equation -- Quad-In
	 */
	@Kroll.constant public static final int QUAD_IN = 1;

	/**
	 * Easing Equation -- Quad-Out
	 */
	@Kroll.constant public static final int QUAD_OUT = 2;

	/**
	 * Easing Equation -- Quad-In-Out
	 */
	@Kroll.constant public static final int QUAD_IN_OUT = 3;

	/**
	 * Easing Equation -- Cubic-In
	 */
	@Kroll.constant public static final int CUBIC_IN = 4;

	/**
	 * Easing Equation -- Cubic-Out
	 */
	@Kroll.constant public static final int CUBIC_OUT = 5;

	/**
	 * Easing Equation -- Cubic-In-Out
	 */
	@Kroll.constant public static final int CUBIC_IN_OUT = 6;

	/**
	 * Easing Equation -- Quart-In
	 */
	@Kroll.constant public static final int QUART_IN = 7;

	/**
	 * Easing Equation -- Quart-Out
	 */
	@Kroll.constant public static final int QUART_OUT = 8;

	/**
	 * Easing Equation -- Quart-In-Out
	 */
	@Kroll.constant public static final int QUART_IN_OUT = 9;

	/**
	 * Easing Equation -- Quint-In
	 */
	@Kroll.constant public static final int QUINT_IN = 10;

	/**
	 * Easing Equation -- Quint-Out
	 */
	@Kroll.constant public static final int QUINT_OUT = 11;

	/**
	 * Easing Equation -- Quint-In-Out
	 */
	@Kroll.constant public static final int QUINT_IN_OUT = 12;

	/**
	 * Easing Equation -- Sine-In
	 */
	@Kroll.constant public static final int SINE_IN = 13;

	/**
	 * Easing Equation -- Sine-Out
	 */
	@Kroll.constant public static final int SINE_OUT = 14;

	/**
	 * Easing Equation -- Sine-In-Out
	 */
	@Kroll.constant public static final int SINE_IN_OUT = 15;

	/**
	 * Easing Equation -- Circ-In
	 */
	@Kroll.constant public static final int CIRC_IN = 16;

	/**
	 * Easing Equation -- Circ-Out
	 */
	@Kroll.constant public static final int CIRC_OUT = 17;

	/**
	 * Easing Equation -- Circ-OutIn
	 */
	@Kroll.constant public static final int CIRC_IN_OUT = 18;

	/**
	 * Easing Equation -- Expo-In
	 */
	@Kroll.constant public static final int EXP_IN = 19;

	/**
	 * Easing Equation -- Expo-Out
	 */
	@Kroll.constant public static final int EXP_OUT = 20;

	/**
	 * Easing Equation -- Expo-In-Out
	 */
	@Kroll.constant public static final int EXP_IN_OUT = 21;

	/**
	 * Easing Equation -- Elastic-In
	 */
	@Kroll.constant public static final int ELASTIC_IN = 22;

	/**
	 * Easing Equation -- Elastic-Out
	 */
	@Kroll.constant public static final int ELASTIC_OUT = 23;

	/**
	 * Easing Equation -- Elastic-In-Out
	 */
	@Kroll.constant public static final int ELASTIC_IN_OUT = 24;

	/**
	 * Easing Equation -- Back-In
	 */
	@Kroll.constant public static final int BACK_IN = 25;

	/**
	 * Easing Equation -- Back-Out
	 */
	@Kroll.constant public static final int BACK_OUT = 26;

	/**
	 * Easing Equation -- Back-In-Out
	 */
	@Kroll.constant public static final int BACK_IN_OUT = 27;

	/**
	 * Easing Equation -- Bounce-In
	 */
	@Kroll.constant public static final int BOUNCE_IN = 28;

	/**
	 * Easing Equation -- Bounce-Out
	 */
	@Kroll.constant public static final int BOUNCE_OUT = 29;

	/**
	 * Easing Equation -- Bounce-In-Out
	 */
	@Kroll.constant public static final int BOUNCE_IN_OUT = 30;

	/**
	 * HashMap of all running TweenManagers
	 */
	protected HashMap<String, TweenManager> animationManagers = new HashMap<String, TweenManager>();

	/**
	 * Constructor
	 *
	 * @return An AnimatorModule instance
	 */
	public AnimatorModule()
	{
		super();

		Tween.registerAccessor(AnimationContainer.class, new AnimationContainerAccessor());
		Tween.setCombinedAttributesLimit(4);
	}

	/**
	 * Life-Cycle Event -- Invoked when the module
	 * gets sent to the background
	 *
	 * @param activity The module activity
	 */
	@Override
	public void onPause(Activity activity)
	{
		super.onPause(activity);
		this.killRunningAnimations();
	}

	/**
	 * Life-Cycle Event -- Invoked when the module
	 * gets killed
	 *
	 * @param activity The module activity
	 */
	@Override
	public void onDestroy(Activity activity)
	{
		super.onPause(activity);
		this.killRunningAnimations();
	}

	/**
	 * Animation factory
	 *
	 * @param proxy    TiViewProxy to animate
	 * @param props    Animation dictionary
	 * @param callback Animation completion callback
	 */
	@Kroll.method
	public void animate(final TiViewProxy proxy, final KrollDict props, @Kroll.argument(optional=true) final KrollFunction callback)
	{
		if (! this.isAnimating(proxy))
		{
			final AnimatorModule self = this;
			final KrollDict animationProps = new KrollDict(props);
			final TweenManager tweenManager = new TweenManager();
			final AnimationContainer accessor = new AnimationContainer(proxy);
			final Timeline sequence = Timeline.createParallel();

			this.setAnimationStart(accessor, animationProps, tweenManager);
			this.buildAnimation(accessor, animationProps, sequence);

			sequence
				.setCallbackTriggers(TweenCallback.COMPLETE|TweenCallback.STEP)
				.setCallback(new TweenCallback() {

					@Override
					public void onEvent(int type, BaseTween<?> source)
					{
						switch (type)
						{
							case STEP:
								accessor.updateLayoutParams();
								break;
							case COMPLETE:
								self.setAnimationComplete(accessor, animationProps);

								if (callback != null)
								{
									callback.call(proxy.getKrollObject(), new KrollDict());
								}
								break;
						}
					}

				})
				.start(tweenManager);
		}
	}

	/**
	 * Builds an animation from supplied
	 * animation dictionary
	 *
	 * @param accessor       Animation container
	 * @param animationProps Animation parameters
	 * @param timeline       Timeline to apply tweens to
	 */
	protected void buildAnimation(final AnimationContainer accessor, final KrollDict animationProps, final Timeline timeline)
	{
		final TiViewProxy proxy = accessor.getProxy();
		final View parentWindow = TiApplication.getAppCurrentActivity().getWindow().getDecorView();
		final View parentView = proxy.getParent() != null ? (View) proxy.getParent().peekView().getOuterView() : null;
		final float duration = this.computeDuration(animationProps);
		final TweenEquation easingFunction = this.determineEasingFunction(animationProps);

		if (animationProps.containsKey(TiC.PROPERTY_TOP))
		{
			TiDimension topDimension = TiConvert.toTiDimension(animationProps, TiC.PROPERTY_TOP, TiDimension.TYPE_TOP);

			if (animationProps.get(TiC.PROPERTY_TOP) == null)
			{
				topDimension = new TiDimension(0, TiDimension.TYPE_TOP);
			}

			timeline.push(Tween.to(accessor, AnimationContainerAccessor.TOP, duration)
					.ease(easingFunction)
					.target(topDimension.getAsPixels(parentWindow)));
		}

		if (animationProps.containsKey(TiC.PROPERTY_LEFT))
		{
			TiDimension leftDimension = TiConvert.toTiDimension(animationProps, TiC.PROPERTY_LEFT, TiDimension.TYPE_LEFT);

			if (animationProps.get(TiC.PROPERTY_LEFT) == null)
			{
				leftDimension = new TiDimension(0, TiDimension.TYPE_LEFT);
			}

			timeline.push(Tween.to(accessor, AnimationContainerAccessor.LEFT, duration)
					.ease(easingFunction)
					.target(leftDimension.getAsPixels(parentWindow)));
		}

		if (animationProps.containsKey(TiC.PROPERTY_BOTTOM))
		{
			TiDimension bottomDimension = TiConvert.toTiDimension(animationProps, TiC.PROPERTY_BOTTOM, TiDimension.TYPE_BOTTOM);

			if (animationProps.get(TiC.PROPERTY_BOTTOM) == null)
			{
				bottomDimension = new TiDimension(0, TiDimension.TYPE_BOTTOM);
			}

			timeline.push(Tween.to(accessor, AnimationContainerAccessor.BOTTOM, duration)
					.ease(easingFunction)
					.target(bottomDimension.getAsPixels(parentWindow)));
		}

		if (animationProps.containsKey(TiC.PROPERTY_RIGHT))
		{
			TiDimension rightDimension = TiConvert.toTiDimension(animationProps, TiC.PROPERTY_RIGHT, TiDimension.TYPE_RIGHT);

			if (animationProps.get(TiC.PROPERTY_RIGHT) == null)
			{
				rightDimension = new TiDimension(0, TiDimension.TYPE_RIGHT);
			}

			timeline.push(Tween.to(accessor, AnimationContainerAccessor.RIGHT, duration)
					.ease(easingFunction)
					.target(rightDimension.getAsPixels(parentWindow)));
		}

		if (animationProps.containsKey(TiC.PROPERTY_WIDTH))
		{
			TiDimension widthDimension = TiConvert.toTiDimension(animationProps, TiC.PROPERTY_WIDTH, TiDimension.TYPE_WIDTH);

			if ((animationProps.get(TiC.PROPERTY_WIDTH) == null || animationProps.get(TiC.PROPERTY_WIDTH).equals(TiC.LAYOUT_FILL)) && parentView != null)
			{
				widthDimension = new TiDimension(parentView.getWidth(), TiDimension.TYPE_WIDTH);
			}

			timeline.push(Tween.to(accessor, AnimationContainerAccessor.WIDTH, duration)
					.ease(easingFunction)
					.target(widthDimension.getAsPixels(parentWindow)));
		}

		if (animationProps.containsKey(TiC.PROPERTY_HEIGHT))
		{
			TiDimension heightDimension = TiConvert.toTiDimension(animationProps, TiC.PROPERTY_HEIGHT, TiDimension.TYPE_HEIGHT);

			if ((animationProps.get(TiC.PROPERTY_HEIGHT) == null || animationProps.get(TiC.PROPERTY_HEIGHT).equals(TiC.LAYOUT_FILL)) && parentView != null)
			{
				heightDimension = new TiDimension(parentView.getHeight(), TiDimension.TYPE_HEIGHT);
			}

			timeline.push(Tween.to(accessor, AnimationContainerAccessor.HEIGHT, duration)
					.ease(easingFunction)
					.target(heightDimension.getAsPixels(parentWindow)));
		}

		if (animationProps.containsKeyAndNotNull(TiC.PROPERTY_CENTER))
		{
			KrollDict centerPosition = animationProps.getKrollDict(TiC.PROPERTY_CENTER);

			if (centerPosition.containsKey(TiC.PROPERTY_X))
			{
				int[] horizontal = new int[2];
				float centerX = TiConvert.toFloat(centerPosition, TiC.PROPERTY_X);
				int width = accessor.getNativeView().getWidth();

				TiCompositeLayout.computePosition(
					parentView,
					null,
					new TiDimension(centerX, TiDimension.TYPE_CENTER_X),
					null,
					width,
					0,
					parentView.getWidth(),
					horizontal
				);

				centerX = horizontal[0] + width / 2;

				timeline.push(Tween.to(accessor, AnimationContainerAccessor.CENTER_X, duration)
						.ease(easingFunction)
						.target(centerX));
			};

			if (centerPosition.containsKey(TiC.PROPERTY_Y))
			{
				int[] vertical = new int[2];
				int height = accessor.getNativeView().getHeight();
				float centerY = TiConvert.toFloat(centerPosition, TiC.PROPERTY_Y);

				TiCompositeLayout.computePosition(
					parentView,
					null,
					new TiDimension(centerY, TiDimension.TYPE_CENTER_Y),
					null,
					height,
					0,
					parentView.getHeight(),
					vertical
				);

				centerY = vertical[0] + height / 2;

				timeline.push(Tween.to(accessor, AnimationContainerAccessor.CENTER_Y, duration)
						.ease(easingFunction)
						.target(centerY));
			}
		}

		if (animationProps.containsKey(TiC.PROPERTY_BACKGROUND_COLOR))
		{
			int backgroundColor = TiConvert.toColor(animationProps, TiC.PROPERTY_BACKGROUND_COLOR);
			float alpha = Color.alpha(backgroundColor),
				  red = Color.red(backgroundColor),
				  green = Color.green(backgroundColor),
				  blue = Color.blue(backgroundColor);

			timeline.push(Tween.to(accessor, AnimationContainerAccessor.BACKGROUND_COLOR, duration)
					.ease(easingFunction)
					.target(alpha, red, green, blue));
		}

		if (animationProps.containsKey(TiC.PROPERTY_ROTATE))
		{
			float rotation = TiConvert.toFloat(animationProps, TiC.PROPERTY_ROTATE);
			Float lastRotation = (Float) proxy.getProperty("__rotation");

			if (lastRotation != null) rotation += lastRotation;

			timeline.push(Tween.to(accessor, AnimationContainerAccessor.ROTATION, duration)
					.ease(easingFunction)
					.target(rotation)
					.setCallback(new TweenCallback() {

						@Override
						public void onEvent(int type, BaseTween<?> source)
						{
							if (type == COMPLETE)
							{
								float endRotation = accessor.getRotation();
								boolean isFullRotation = endRotation % 360 == 0;

								if (isFullRotation) accessor.setRotation(0f);

								proxy.setProperty("__rotation", isFullRotation ? 0f : endRotation);
							}
						}

					}));
		}

		if (animationProps.containsKey(TiC.PROPERTY_OPACITY))
		{
			float opacity = TiConvert.toFloat(animationProps, TiC.PROPERTY_OPACITY);

			if (opacity > 1f)
			{
				opacity = 1f;
			}
			else if (opacity < 0f)
			{
				opacity = 0f;
			}

			timeline.push(Tween.to(accessor, AnimationContainerAccessor.OPACITY, duration)
					.ease(easingFunction)
					.target(opacity));
		}
	}

	/**
	 * Start the animation
	 *
	 * @param accessor       Animation container
	 * @param animationProps Animation parameters
	 * @param manager        Manager associated to the animation
	 */
	protected void setAnimationStart(AnimationContainer accessor, KrollDict animationProps, TweenManager manager)
	{
		final TiViewProxy proxy = accessor.getProxy();
		final String animationId = UUID.randomUUID().toString();

		proxy.setProperty("__animationId", animationId);
		proxy.setProperty("__animating", true);

		this.animationManagers.put(animationId, manager);

		this.setAnimationThread(proxy, manager, this.getActivity());
	}

	/**
	 * End the animation
	 *
	 * @param accessor       Animation container
	 * @param animationProps Animation parameters
	 */
	protected void setAnimationComplete(AnimationContainer accessor, KrollDict animationProps)
	{
		final TiViewProxy proxy = accessor.getProxy();
		final String animationId = (String) proxy.getProperty("__animationId");
		final TiCompositeLayout.LayoutParams layoutParams = accessor.getLayoutParams();

		this.animationManagers.remove(animationId);

		if (animationProps.containsKeyAndNotNull(TiC.PROPERTY_WIDTH) && ! animationProps.get(TiC.PROPERTY_WIDTH).equals(TiC.LAYOUT_FILL))
		{
			animationProps.remove(TiC.PROPERTY_WIDTH);
		}

		if (animationProps.containsKeyAndNotNull(TiC.PROPERTY_HEIGHT) && ! animationProps.get(TiC.PROPERTY_HEIGHT).equals(TiC.LAYOUT_FILL))
		{
			animationProps.remove(TiC.PROPERTY_HEIGHT);
		}

		if (TiConvert.fillLayout(animationProps, layoutParams))
		{
			accessor.getNativeView().setLayoutParams(layoutParams);
		}

		proxy.setProperty("__animationId", null);
		proxy.setProperty("__animating", false);
	}

	/**
	 * Update the Tween manager from a
	 * background thread
	 *
	 * @param proxy    The TiViewProxy being animated
	 * @param manager  The TweenManager to use
	 * @param activity The current activity
	 */
	protected void setAnimationThread(final TiViewProxy proxy, final TweenManager manager, final Activity activity)
	{
		final AnimatorModule self = this;

		new Thread(new Runnable() {
		    private long lastMillis = -1;

		    @Override
		    public void run() {
		        while (self.isAnimating(proxy))
		        {
		            if (lastMillis > 0)
		            {
		                final long currentMillis = System.currentTimeMillis();
		                final float delta = (currentMillis - lastMillis) / 1000f;

		                activity.runOnUiThread(new Runnable() {
		                    @Override public void run() {
		                    	manager.update(delta);
		                    }
		                });

		                lastMillis = currentMillis;
		            }
		            else
		            {
		                lastMillis = System.currentTimeMillis();
		            }

		            try
		            {
		                Thread.sleep(1000 / 60);
		            }
		            catch(InterruptedException ex)
		            {
		            	// NOOP
		            }
		        }
		    }
		}).start();
	}

	/**
	 * Kill all running animations
	 * and immediately apply their
	 * completion state
	 */
	protected void killRunningAnimations()
	{
		final Iterator<Entry<String, TweenManager>> animationsIterator = this.animationManagers.entrySet().iterator();

		while (animationsIterator.hasNext())
		{
			final Entry<String, TweenManager> entry = animationsIterator.next();
			final TweenManager manager = entry.getValue();

			manager.pause();
			manager.killAll();

			animationsIterator.remove();
		}

		this.animationManagers.clear();
	}

	/**
	 * Gets a supplied proxy's animation
	 * state
	 *
	 * @param  proxy A TiViewProxy
	 * @return Status of a proxy's animation
	 */
	protected boolean isAnimating(final TiViewProxy proxy)
	{
		return proxy.hasProperty("__animating") ? TiConvert.toBoolean(proxy.getProperty("__animating")) : false;
	}

	/**
	 * Compute the duration from the
	 * supplied animation properties
	 *
	 * @param  animationProps A dictionary of properties
	 * @return The computed duration
	 */
	protected float computeDuration(final KrollDict animationProps)
	{
		float duration = animationProps.containsKey(TiC.PROPERTY_DURATION) ? TiConvert.toFloat(animationProps, TiC.PROPERTY_DURATION) : 0.25f;

		if (duration > 0)
		{
			duration /= 1000;
		}

		return duration;
	}

	/**
	 * Determine the easing function to use
	 * from a set of animation properties. The
	 * default easing function is LINEAR
	 *
	 * @param  animationProps A dictionary of properties
	 * @return An easing function constant
	 */
	protected TweenEquation determineEasingFunction(final KrollDict animationProps)
	{
		if (animationProps.containsKeyAndNotNull("easing"))
		{
			switch (TiConvert.toInt(animationProps, "easing"))
			{
				case AnimatorModule.QUAD_IN:
					return Quad.IN;
				case AnimatorModule.QUAD_OUT:
					return Quad.OUT;
				case AnimatorModule.QUAD_IN_OUT:
					return Quad.INOUT;
				case AnimatorModule.CUBIC_IN:
					return Cubic.IN;
				case AnimatorModule.CUBIC_OUT:
					return Cubic.OUT;
				case AnimatorModule.CUBIC_IN_OUT:
					return Cubic.INOUT;
				case AnimatorModule.QUART_IN:
					return Quart.IN;
				case AnimatorModule.QUART_OUT:
					return Quart.OUT;
				case AnimatorModule.QUART_IN_OUT:
					return Quart.INOUT;
				case AnimatorModule.QUINT_IN:
					return Quint.IN;
				case AnimatorModule.QUINT_OUT:
					return Quint.OUT;
				case AnimatorModule.QUINT_IN_OUT:
					return Quint.INOUT;
				case AnimatorModule.SINE_IN:
					return Sine.IN;
				case AnimatorModule.SINE_OUT:
					return Sine.OUT;
				case AnimatorModule.SINE_IN_OUT:
					return Sine.INOUT;
				case AnimatorModule.CIRC_IN:
					return Circ.IN;
				case AnimatorModule.CIRC_OUT:
					return Circ.OUT;
				case AnimatorModule.CIRC_IN_OUT:
					return Circ.INOUT;
				case AnimatorModule.EXP_IN:
					return Expo.IN;
				case AnimatorModule.EXP_OUT:
					return Expo.OUT;
				case AnimatorModule.EXP_IN_OUT:
					return Expo.INOUT;
				case AnimatorModule.ELASTIC_IN:
					return Elastic.IN;
				case AnimatorModule.ELASTIC_OUT:
					return Elastic.OUT;
				case AnimatorModule.ELASTIC_IN_OUT:
					return Elastic.INOUT;
				case AnimatorModule.BACK_IN:
					return Back.IN;
				case AnimatorModule.BACK_OUT:
					return Back.OUT;
				case AnimatorModule.BACK_IN_OUT:
					return Back.INOUT;
				case AnimatorModule.BOUNCE_IN:
					return Bounce.IN;
				case AnimatorModule.BOUNCE_OUT:
					return Bounce.OUT;
				case AnimatorModule.BOUNCE_IN_OUT:
					return Bounce.INOUT;
			}
		}
		
		return Linear.INOUT;
	}
}