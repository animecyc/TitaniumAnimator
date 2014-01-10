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

import org.appcelerator.titanium.TiC;
import org.appcelerator.titanium.TiDimension;
import org.appcelerator.titanium.proxy.TiViewProxy;
import org.appcelerator.titanium.util.TiConvert;
import org.appcelerator.titanium.view.TiCompositeLayout;

import android.graphics.Color;
import android.view.View;

public class AnimationContainer
{

	/**
	 * A TiViewProxy
	 */
	protected TiViewProxy proxy;

	/**
	 * A TiUIView's native view
	 */
	protected View nativeView;

	/**
	 * A native views composite layout parameters
	 */
	protected TiCompositeLayout.LayoutParams layoutParams;

	/**
	 * Constructor
	 *
	 * @param  proxy The TiViewProxy being accessed
	 * @return An instance of AnimationContainer
	 */
	public AnimationContainer(TiViewProxy proxy)
	{
		this.proxy = proxy;
		this.nativeView = (View) proxy.peekView().getOuterView();
		this.layoutParams = (TiCompositeLayout.LayoutParams) this.nativeView.getLayoutParams();
	}

	/**
	 * Set a specific dimension on
	 * the container's TiViewProxy
	 *
	 * @param top     A TiDimension.TYPE_TOP
	 * @param left    A TiDimension.TYPE_LEFT
	 * @param bottom  A TiDimension.TYPE_BOTTOM
	 * @param right   A TiDimension.TYPE_RIGHT
	 * @param centerX A TiDimension.TYPE_CENTER_X
	 * @param centerY A TiDimension.TYPE_CENTER_Y
	 * @param width   A TiDimension.TYPE_WIDTH
	 * @param height  A TiDimension.TYPE_HEIGHT
	 */
	public void setDimensions(Float top, Float left, Float bottom, Float right, Float centerX, Float centerY, Float width, Float height)
	{
		if (top != null)
		{
			this.layoutParams.optionTop = new TiDimension(top, TiDimension.TYPE_TOP);
		}

		if (left != null)
		{
			this.layoutParams.optionLeft = new TiDimension(left, TiDimension.TYPE_LEFT);
		}

		if (bottom != null)
		{
			this.layoutParams.optionBottom = new TiDimension(bottom, TiDimension.TYPE_BOTTOM);
		}

		if (right != null)
		{
			this.layoutParams.optionRight = new TiDimension(right, TiDimension.TYPE_RIGHT);
		}

		if (centerX != null)
		{
			this.layoutParams.optionCenterX = new TiDimension(centerX, TiDimension.TYPE_CENTER_X);
		}

		if (centerY != null)
		{
			this.layoutParams.optionCenterY = new TiDimension(centerY, TiDimension.TYPE_CENTER_Y);
		}

		if (width != null)
		{
			this.layoutParams.optionWidth = new TiDimension(width, TiDimension.TYPE_WIDTH);
		}

		if (height != null)
		{
			this.layoutParams.optionHeight = new TiDimension(height, TiDimension.TYPE_HEIGHT);
		}
	}

	/**
	 * Get the currently set background
	 * color from the TiViewProxy
	 *
	 * @return A color
	 */
	public int getBackgroundColor()
	{
		int backgroundColor;

        if (this.proxy.hasProperty(TiC.PROPERTY_BACKGROUND_COLOR))
        {
        	String _backgroundColor = TiConvert.toString(this.proxy.getProperty(TiC.PROPERTY_BACKGROUND_COLOR));
        	backgroundColor = TiConvert.toColor(_backgroundColor);
        }
        else
        {
        	backgroundColor = Color.argb(0, 0, 0, 0);
        }

		return backgroundColor;
	}

	/**
	 * Set the background color on the
	 * container's TiViewProxy
	 *
	 * @param backgroundColor The color to set
	 */
	public void setBackgroundColor(int backgroundColor)
	{
		this.proxy.setPropertyAndFire(TiC.PROPERTY_BACKGROUND_COLOR, String.format("#%06X", (0xFFFFFF & backgroundColor)));
	}

	/**
	 * Get the current rotation from
	 * the container's TiViewProxy
	 *
	 * @return [description]
	 */
	public float getRotation()
	{
		return this.nativeView.getRotation();
	}

	/**
	 * Set the rotation on the container's
	 * TiViewProxy
	 *
	 * @param rotation The rotation angle
	 */
	public void setRotation(float rotation)
	{
		this.nativeView.setRotation(rotation);
	}

	/**
	 * Get the current alpha from
	 * the container's TiViewProxy
	 *
	 * @return A value from 0 to 1
	 */
	public float getAlpha()
	{
		return this.nativeView.getAlpha();
	}

	/**
	 * Set the container's TiViewProxy's
	 * alpha
	 *
	 * @param alpha A value from 0 to 1
	 */
	public void setAlpha(float alpha)
	{
		this.proxy.setPropertyAndFire("opacity", alpha);
	}

	/**
	 * Get the container's TiViewProxy
	 * layout parameters
	 *
	 * @return The currently set layout parameters
	 */
	public TiCompositeLayout.LayoutParams getLayoutParams()
	{
		return this.layoutParams;
	}

	/**
	 * Update the currently set TiViewProxy's
	 * layout parameters
	 */
	public void updateLayoutParams()
	{
		this.nativeView.setLayoutParams(this.layoutParams);
	}

	/**
	 * Get the container's native view
	 *
	 * @return A view
	 */
	public View getNativeView()
	{
		return this.nativeView;
	}

	/**
	 * Get the container's proxy
	 *
	 * @return A TiViewProxy
	 */
	public TiViewProxy getProxy()
	{
		return this.proxy;
	}

}