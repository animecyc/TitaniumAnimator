# TitaniumAnimator

A drop-in animation replacement for Titanium. This module's aim is to mimick as much of the Titanium animation module as possible with the addition of new timing functions and better performance. As of right now the only properties that can be animated are: `rotate`, `transform`, `top`, `bottom`, `left`, `right`, `width`, `height`, `opacity`, `color` and `backgroundColor`.

## Rotations

If you need to perform a rotation you can pass the `rotate` property which accepts a float. The `rotate` property is the angle you wish to rotate to; A positive value will result in a counter-clockwise rotation, while a negative value will result in a clockwise rotation.

Once a rotation has been performed subsequent rotations will be performed from its last rotation angle. To simplify multiple rotations you can pass values > 360. For example to do two complete rotations you can pass a value of 720.

## Support

* iOS: iOS6+
* Android: Forthcoming

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

## [TiDraggable](https://github.com/animecyc/TiDraggable) Support

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