/**
 * Copyright (c) 2015 Seth Benjamin
 * All rights reserved.

 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */
var TiAnimator = require('com.animecyc.animator');

// ==

var appWindow = Ti.UI.createWindow({
  backgroundColor: '#FFFFFF'
});

var block = Ti.UI.createView({
  width: 100,
  height: 100,
  backgroundColor: '#A6A6A6'
});

appWindow.addEventListener('open', function() {
  (function repeatForever() {
    TiAnimator.animate(block, {
      width: 50,
      height: 50,
      backgroundColor: '#FFFFFF',
      duration: 500,
      easing: TiAnimator.EXPO_OUT
    }, function() {
      TiAnimator.animate(block, {
        width: 100,
        height: 100,
        backgroundColor: '#A6A6A6',
        duration: 500,
        easing: TiAnimator.EXPO_OUT
      }, repeatForever);
    });
  }());
});

appWindow.add(block);
appWindow.open();
