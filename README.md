# TiAnimator
> A replacement for Titanium's view animations.

## Features
* Fast performant animations
* Eleven different easing functions
* Works with absolute, vertical, and horizontal layouts
* Honors content sizing in Ti.UI.ScrollViews
* Supports multiple concurrent animations

## Usage
Somewhere in your project include the module...
```javascript
var TiAnimator = require('com.animecyc.animator');
```
... and then animate your views!
```javascript
TiAnimator.animate(blockView, {
  backgroundColor: '#A6A6A6',
  duration: 500
}, function() {
  // animation complete!
});
```

## API
The API is similar to Titanium's animation API. In fact it was modeled after it. There is only one entry point and it couldn't be easier to use.

#### `animate(view, properties, [callback])`
The `animate` method requires a view and a dictionary of properties for the animation. You can optionally pass in a callback function to be executed when the animation is completed.

**Supported Properties:** `easing`, `duration`, `width`, `height`, `top`, `bottom`, `left`, `right`, `rotate`, `opacity`, `backgroundColor`, `color`

## Easing
You can use any one of the listed easing functions by specifying the `easing` property in your animation properties. You can see examples of each of these [here](http://easings.net/).

Function    | In           | Out           | In-Out
----------- | :----------: | :-----------: | :--------------:
**Linear**  | `LINEAR`     | *             | *
**Quad**    | `QUAD_IN`    | `QUAD_OUT`    | `QUAD_IN_OUT`
**Cubic**   | `CUBIC_IN`   | `CUBIC_OUT`   | `CUBIC_IN_OUT`
**Quart**   | `QUART_IN`   | `QUART_OUT`   | `QUART_IN_OUT`
**Quint**   | `QUINT_IN`   | `QUINT_OUT`   | `QUINT_IN_OUT`
**Sine**    | `SINE_IN`    | `SINE_OUT`    | `SINE_IN_OUT`
**Circ**    | `CIRC_IN`    | `CIRC_OUT`    | `CIRC_IN_OUT`
**Expo**    | `EXPO_IN`    | `EXPO_OUT`    | `EXPO_IN_OUT`
**Elastic** | `ELASTIC_IN` | `ELASTIC_OUT` | `ELASTIC_IN_OUT`
**Back**    | `BACK_IN`    | `BACK_OUT`    | `BACK_IN_OUT`
**Bounce**  | `BOUNCE_IN`  | `BOUNCE_OUT`  | `BOUNCE_IN_OUT`

## Contributing
Have something you want to contribute? Fantastic! I welcome all kinds of pull-requests from code additions to documentation updates. Feel free to submit a PR and I'll review it as soon as I am able to. If you are contributing code please adhere to the code style provided ([iOS](iphone/.clang-format)) with the project.

## License
```
The MIT License (MIT)

Copyright (c) 2015 Seth Benjamin

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
