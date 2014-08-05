/*global require,Ti*/
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
(function () {
    'use strict';

    var Animator = require('com.animecyc.animator'),
        mainWindow = Ti.UI.createWindow({
            fullscreen : true,
            backgroundColor : 'white'
        }),
        viewToAnimate = Ti.UI.createView({
            height : 100,
            top : 0,
            backgroundColor : 'red'
        }),
        easingMethod = Animator.LINEAR,
        easeSelect = Ti.UI.createPicker({
            selectionIndicator : true
        }),
        easeSelectView = Ti.UI.createView({
            height : 100,
            bottom : 0,
            clipMode : Ti.UI.iOS.CLIP_MODE_ENABLED
        });

    easeSelect.add([
        Ti.UI.createPickerRow({ title : 'LINEAR' }),
        Ti.UI.createPickerRow({ title : 'QUAD_IN' }),
        Ti.UI.createPickerRow({ title : 'QUAD_OUT' }),
        Ti.UI.createPickerRow({ title : 'QUAD_IN_OUT' }),
        Ti.UI.createPickerRow({ title : 'CUBIC_IN' }),
        Ti.UI.createPickerRow({ title : 'CUBIC_OUT' }),
        Ti.UI.createPickerRow({ title : 'CUBIC_IN_OUT' }),
        Ti.UI.createPickerRow({ title : 'QUART_IN' }),
        Ti.UI.createPickerRow({ title : 'QUART_OUT' }),
        Ti.UI.createPickerRow({ title : 'QUART_IN_OUT' }),
        Ti.UI.createPickerRow({ title : 'QUINT_IN' }),
        Ti.UI.createPickerRow({ title : 'QUINT_OUT' }),
        Ti.UI.createPickerRow({ title : 'QUINT_IN_OUT' }),
        Ti.UI.createPickerRow({ title : 'SINE_IN' }),
        Ti.UI.createPickerRow({ title : 'SINE_OUT' }),
        Ti.UI.createPickerRow({ title : 'SINE_IN_OUT' }),
        Ti.UI.createPickerRow({ title : 'CIRC_IN' }),
        Ti.UI.createPickerRow({ title : 'CIRC_OUT' }),
        Ti.UI.createPickerRow({ title : 'CIRC_IN_OUT' }),
        Ti.UI.createPickerRow({ title : 'EXP_IN' }),
        Ti.UI.createPickerRow({ title : 'EXP_OUT' }),
        Ti.UI.createPickerRow({ title : 'EXP_IN_OUT' }),
        Ti.UI.createPickerRow({ title : 'ELASTIC_IN' }),
        Ti.UI.createPickerRow({ title : 'ELASTIC_OUT' }),
        Ti.UI.createPickerRow({ title : 'ELASTIC_IN_OUT' }),
        Ti.UI.createPickerRow({ title : 'BACK_IN' }),
        Ti.UI.createPickerRow({ title : 'BACK_OUT' }),
        Ti.UI.createPickerRow({ title : 'BACK_IN_OUT' }),
        Ti.UI.createPickerRow({ title : 'BOUNCE_IN' }),
        Ti.UI.createPickerRow({ title : 'BOUNCE_OUT' }),
        Ti.UI.createPickerRow({ title : 'BOUNCE_IN_OUT' }),
    ]);

    easeSelect.addEventListener('change', function (e) {
        easingMethod = Animator[e.row.title];
    });

    viewToAnimate.addEventListener('singletap', function () {
        Animator.animate(viewToAnimate, {
            rotate : 180,
            backgroundColor : 'green',
            top : (Ti.Platform.displayCaps.platformHeight - 199) + 'dp',
            width : '50%',
            opacity : 0.5,
            duration : 3000,
            easing : easingMethod
        }, function () {
            Animator.animate(viewToAnimate, {
                rotate : 180,
                backgroundColor : 'red',
                top : 0,
                width : Ti.UI.FILL,
                opacity : 1,
                duration : 3000,
                easing : easingMethod
            });
        });
    });

    easeSelectView.add(easeSelect);
    mainWindow.add(Ti.UI.createView({
        height : 1,
        backgroundColor : '#A5A5A5',
        bottom : 100
    }));
    mainWindow.add(easeSelectView);
    mainWindow.add(viewToAnimate);
    mainWindow.open();
}());
