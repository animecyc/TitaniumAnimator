# TitaniumAnimator

A drop-in animation replacement for Titanium. This module's aim is to mimick as much of the Titanium animation module as possible with the addition of new timing functions and better performance. As of right now the only properties that can be animated are: `top`, `bottom`, `left`, `right`, `width`, `height`, `opacity`, and `backgroundColor`.

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