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

import org.appcelerator.titanium.view.TiCompositeLayout;

import android.graphics.Color;
import aurelienribon.tweenengine.TweenAccessor;

public class AnimationContainerAccessor implements TweenAccessor<AnimationContainer>
{

	/**
	 * Accessor Constant - Top Edge
	 */
	public static final int TOP = 1;

	/**
	 * Accessor Constant - Left Edge
	 */
	public static final int LEFT = 2;

	/**
	 * Accessor Constant - Bottom Edge
	 */
	public static final int BOTTOM = 3;

	/**
	 * Accessor Constant - Right Edge
	 */
	public static final int RIGHT = 4;

	/**
	 * Accessor Constant - Center-X
	 */
	public static final int CENTER_X = 5;

	/**
	 * Accessor Constant - Center-Y
	 */
	public static final int CENTER_Y = 6;

	/**
	 * Accessor Constant - Width
	 */
	public static final int WIDTH = 7;

	/**
	 * Accessor Constant - Height
	 */
	public static final int HEIGHT = 8;

	/**
	 * Accessor Constant - Background Color
	 */
	public static final int BACKGROUND_COLOR = 9;
	
	/**
	 * Accessor Constant - Background Color
	 */
	public static final int COLOR = 10;

	/**
	 * Accessor Constant - Rotation
	 */
	public static final int ROTATION = 11;

	/**
	 * Accessor Constant - Alpha
	 */
	public static final int OPACITY = 12;

	/**
	 * Get values to interpolate
	 *
	 * @param  target       Accessor to get values from
	 * @param  tweenType    Value to get
	 * @param  returnValues Values to interpolate
	 * @return The number of values
	 */
	@Override
	public int getValues(AnimationContainer target, int tweenType, float[] returnValues)
	{
		TiCompositeLayout.LayoutParams layoutParams = null;

		if (tweenType > 0 && tweenType < 9) {
			layoutParams = target.getLayoutParams();
		}

		switch (tweenType)
		{
			case TOP:
				if (layoutParams != null)
				{
					returnValues[0] = (float) (layoutParams.optionTop == null ? 0 : layoutParams.optionTop.getValue());

					return 1;
				}

				return 0;
			case LEFT:
				if (layoutParams != null)
				{
					returnValues[0] = (float) (layoutParams.optionLeft == null ? 0 : layoutParams.optionLeft.getValue());

					return 1;
				}

				return 0;
			case BOTTOM:
				if (layoutParams != null)
				{
					returnValues[0] = (float) (layoutParams.optionBottom == null ? 0 : layoutParams.optionBottom.getValue());

					return 1;
				}

				return 0;
			case RIGHT:
				if (layoutParams != null)
				{
					returnValues[0] = (float) (layoutParams.optionRight == null ? 0 : layoutParams.optionRight.getValue());

					return 1;
				}

				return 0;
			case CENTER_X:
				if (layoutParams != null)
				{
					returnValues[0] = (float) (target.getNativeView().getLeft() + target.getNativeView().getWidth() / 2);

					return 1;
				}

				return 0;
			case CENTER_Y:
				if (layoutParams != null)
				{
					returnValues[0] = (float) (target.getNativeView().getTop() + target.getNativeView().getHeight() / 2);

					return 1;
				}

				return 0;
			case WIDTH:
				if (layoutParams != null)
				{
					returnValues[0] = (float) (layoutParams.optionWidth == null ? target.getNativeView().getWidth() : layoutParams.optionWidth.getValue());

					return 1;
				}

				return 0;
			case HEIGHT:
				if (layoutParams != null)
				{
					returnValues[0] = (float) (layoutParams.optionHeight == null ? target.getNativeView().getHeight() : layoutParams.optionHeight.getValue());

					return 1;
				}

				return 0;
			case BACKGROUND_COLOR:
				final int backgroundColor = target.getBackgroundColor();

				returnValues[0] = Color.alpha(backgroundColor);
				returnValues[1] = Color.red(backgroundColor);
				returnValues[2] = Color.green(backgroundColor);
				returnValues[3] = Color.blue(backgroundColor);

				return 4;
			case COLOR:
				final int color = target.getColor();

				returnValues[0] = Color.alpha(color);
				returnValues[1] = Color.red(color);
				returnValues[2] = Color.green(color);
				returnValues[3] = Color.blue(color);

				return 4;
			case ROTATION:
				returnValues[0] = target.getRotation();

				return 1;
			case OPACITY:
				returnValues[0] = target.getAlpha();

				return 1;
		}

		return 0;
	}

	/**
	 * Set interpolated values
	 *
	 * @param  target       Accessor to get values from
	 * @param  tweenType    Value to get
	 * @param  newValues    Interpolated values
	 */
	@Override
	public void setValues(AnimationContainer target, int tweenType, float[] newValues)
	{
		switch (tweenType)
		{
			case TOP:
				if (newValues.length > 0)
				{
					target.setDimensions(newValues[0], null, null, null, null, null, null, null);
				}
				break;
			case LEFT:
				if (newValues.length > 0)
				{
					target.setDimensions(null, newValues[0], null, null, null, null, null, null);
				}
				break;
			case BOTTOM:
				if (newValues.length > 0)
				{
					target.setDimensions(null, null, newValues[0], null, null, null, null, null);
				}
				break;
			case RIGHT:
				if (newValues.length > 0)
				{
					target.setDimensions(null, null, null, newValues[0], null, null, null, null);
				}
				break;
			case CENTER_X:
				if (newValues.length > 0)
				{
					target.setDimensions(null, null, null, null, newValues[0], null, null, null);
				}
				break;
			case CENTER_Y:
				if (newValues.length > 0)
				{
					target.setDimensions(null, null, null, null, null, newValues[0], null, null);
				}
				break;
			case WIDTH:
				if (newValues.length > 0)
				{
					target.setDimensions(null, null, null, null, null, null, newValues[0], null);
				}
				break;
			case HEIGHT:
				if (newValues.length > 0)
				{
					target.setDimensions(null, null, null, null, null, null, null, newValues[0]);
				}
				break;
			case BACKGROUND_COLOR:
				if (newValues.length > 3)
				{
					int alpha = (int) newValues[0],
						red = (int) newValues[1],
						green = (int) newValues[2],
						blue = (int) newValues[3];

					target.setBackgroundColor(Color.argb(alpha, red, green, blue));
				}
				break;
			case COLOR:
				if (newValues.length > 3)
				{
					int alpha = (int) newValues[0],
						red = (int) newValues[1],
						green = (int) newValues[2],
						blue = (int) newValues[3];

					target.setColor(Color.argb(alpha, red, green, blue));
				}
				break;
			case ROTATION:
				if (newValues.length > 0)
				{
					target.setRotation(newValues[0]);
				}
				break;
			case OPACITY:
				if (newValues.length > 0)
				{
					target.setAlpha(newValues[0]);
				}
				break;
		}
	}

}