# TitaniumAnimator

A drop-in animation replacement for Titanium. This module's aim is to mimick as much of the Titanium animation module as possible with the addition of new timing functions and better performance. As of right now the only properties that can be animated are: `rotate`, `transform`, `top`, `bottom`, `left`, `right`, `width`, `height`, `opacity`, `color` and `backgroundColor`. The `transform` property is not supported by Android at this time.

For performance reasons iOS has a special boolean property called `opaque` which can be set to `true`. If you are animating views that don't contain any sort of transparency you will see performance gains when animating large or otherwise complex view groups.

## Support

* iOS: iOS6+
* Android: 3.0+

## Usage

```javascript
var Animator = require('com.animecyc.animator'),
    mainWindow = Ti.UI.createWindow({
        backgroundColor : 'white'
    }),
    animationView = Ti.UI.createView({
    	backgroundColor : 'red',
    	width : 100,
    	height : 100
    });

animationView.addEventListener('click', function () {
	Animator.animate(animationView, {
		duration : 1000,
		easing : Animator.BOUNCE_OUT,
		width : 150,
		height : 150,
		backgroundColor : 'blue',
		opacity : 0.5,
		bottom : 0
	}, function () {
		Animator.animate(animationView, {
			duration : 1000,
			easing : Animator.BOUNCE_OUT,
			width : 100,
			height : 100,
			backgroundColor : 'red',
			opacity : 1,
			bottom : null
		});
	});
});

mainWindow.add(animationView);
mainWindow.open();
```

## Rotations

If you need to perform a rotation you can pass the `rotate` property which accepts a float. The `rotate` property is the angle you wish to rotate to; A positive value will result in a counter-clockwise rotation, while a negative value will result in a clockwise rotation.

Once a rotation has been performed subsequent rotations will be performed from its last rotation angle. To simplify multiple rotations you can pass values > 360. For example to do two complete rotations you can pass a value of 720.

## Text Color

In order to animate the text color of a Ti.UI.Label on iOS you must use a compatiable label replacement. You can get a simple version here: [TitaniumCoreLabel](https://github.com/animecyc/TitaniumCoreLabel).

```javascript
var CoreLabel = require('com.animecyc.corelabel'),
	Animator = require('com.animecyc.animator'),
	testLabel = CoreLabel.createLabel({
		color : 'black',
		font : {
			fontSize : 15
		}
	});

Animator.animate(testLabel, {
	color : 'blue',
	duration : 500
});
```

> The only property that can be animated on a label created via CoreLabel is the `color` property. The `font` property is forthcoming.

## Layout Support

When animating views on iOS in a horizontal or vertical layout sibling views will *pop* into place as opposed to animating to the correct position. You can pass the `siblings` flag to the animation properties to ensure that all sibling views animate to their correct location. By default this flag is set to `false`.

When animating a complex layout (such as a vertical layout inside a vertical layout) it may be necessary to specify which parent to propogate the animimations from, you can do this by setting `parentForAnimation` and passing the proxy that holds the views that should animate. This is especially useful in cases where you are animating inside of a `Ti.UI.ScrollView`.

> There is the possibility of a hit in performace when animating large quantities of sibling views together especially on iOS6.

## Animation Batching (iOS only)

When animating large amounts of views the UI can become unresponsive. This can be avoided in most situations by wrapping the animating proxies in a transaction.

```javascript
Animator.animationTransaction(function () {
	Animator.animate( ... );
	Animator.animate( ... );
	Animator.animate( ... );
});
```

## [TiDraggable](https://github.com/animecyc/TiDraggable) Support (iOS only)

If the view you're animating is a view touched by [TiDraggable](https://github.com/animecyc/TiDraggable) module you can perform a tandem animation; All attached proxies will be animated at the same time within the supplied constraints.

```javascript
Animator.animate(animationView, {
	duration : 1000,
	easing : Animator.BOUNCE_OUT,
	left : 250,
	draggable : {
		x : 'end'
	}
});
```

Given the above usage example, if the view being animated has views "attached" to it, via the `maps` declaration, you can have them animate their position into place as if it were being panned. This creates a fluid expirience for situations where you need to have both drag and drop support and animations between multiple related views.

Both `draggable` property axes (x & y) support the use of either a string representing the key used for the axis constraint on the draggable configuration or an integer for custom arrangements.

## Easing Functions

The below easing functions can be accessed as you would any other Titanium constant. Assuming the above usage example you can access all of these by passing the below name to the module, such as in: `Animator.ELASTIC_IN_OUT`

* LINEAR (default)
* QUAD_IN
* QUAD_OUT
* QUAD_IN_OUT
* CUBIC_IN
* CUBIC_OUT
* CUBIC_IN_OUT
* QUART_IN
* QUART_OUT
* QUART_IN_OUT
* QUINT_IN
* QUINT_OUT
* QUINT_IN_OUT
* SINE_IN
* SINE_OUT
* SINE_IN_OUT
* CIRC_IN
* CIRC_OUT
* CIRC_IN_OUT
* EXP_IN
* EXP_OUT
* EXP_IN_OUT
* ELASTIC_IN
* ELASTIC_OUT
* ELASTIC_IN_OUT
* BACK_IN
* BACK_OUT
* BACK_IN_OUT
* BOUNCE_IN
* BOUNCE_OUT
* BOUNCE_IN_OUT