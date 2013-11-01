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
            fullscreen : true
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
            backgroundColor : 'white'
        }),
        createRow = function (title) {
            return Ti.UI.createPickerRow({
                title : title
            });
        };

    easeSelect.add([
        createRow('LINEAR'),
        createRow('QUAD_IN'),
        createRow('QUAD_OUT'),
        createRow('QUAD_IN_OUT'),
        createRow('CUBIC_IN'),
        createRow('CUBIC_OUT'),
        createRow('CUBIC_IN_OUT'),
        createRow('QUART_IN'),
        createRow('QUART_OUT'),
        createRow('QUART_IN_OUT'),
        createRow('QUINT_IN'),
        createRow('QUINT_OUT'),
        createRow('QUINT_IN_OUT'),
        createRow('SINE_IN'),
        createRow('SINE_OUT'),
        createRow('SINE_IN_OUT'),
        createRow('CIRC_IN'),
        createRow('CIRC_OUT'),
        createRow('CIRC_IN_OUT'),
        createRow('EXP_IN'),
        createRow('EXP_OUT'),
        createRow('EXP_IN_OUT'),
        createRow('ELASTIC_IN'),
        createRow('ELASTIC_OUT'),
        createRow('ELASTIC_IN_OUT'),
        createRow('BACK_IN'),
        createRow('BACK_OUT'),
        createRow('BACK_IN_OUT'),
        createRow('BOUNCE_IN'),
        createRow('BOUNCE_OUT'),
        createRow('BOUNCE_IN_OUT')
    ]);

    easeSelect.addEventListener('change', function (e) {
        easingMethod = Animator[e.row.title];
    });

    viewToAnimate.addEventListener('singletap', function () {
        Animator.animate(viewToAnimate, {
            backgroundColor : 'green',
            top : Ti.Platform.displayCaps.platformHeight - 200,
            width : "50%",
            duration : 500,
            easing : easingMethod
        }, function () {
            Animator.animate(viewToAnimate, {
                backgroundColor : 'red',
                top : 0,
                width : null,
                duration : 500,
                easing : easingMethod
            });
        });
    });

    easeSelectView.add(easeSelect);
    mainWindow.add(easeSelectView);
    mainWindow.add(viewToAnimate);
    mainWindow.open();
}());