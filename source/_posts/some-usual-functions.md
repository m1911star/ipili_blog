---
title: 常见函数封装 (1)
date: 2016-07-23 15:24:23
tags:
  - Object function
  - Javascript

---
一些常见js函数的封装
<!-- more -->

**Object.assign函数**

	if (typeof Object.assign != 'function') {
    	Object.assign = function(target) {
        	'use strict';
        	if (target == null) {
            	throw new TypeError('Cannot convert undefined or null to object');
        	}

        	target = Object(target);
        	for (var index = 1; index < arguments.length; index++) {
            	var source = arguments[index];
            	if (source != null) {
                	for (var key in source) {
                    	if (Object.prototype.hasOwnProperty.call(source, key)) {
                        	target[key] = source[key];
                    	}
                	}
            	}
        	}
        	return target;
    	};
	}

**createClass函数**

	var _createClass = function() {
    	function defineProperties(target, props) {
        	for (var i = 0; i < props.length; i++) {
            	var descriptor = props[i];
            	descriptor.enumerable = descriptor.enumerable || false;
            	descriptor.configurable = true;
            	if ("value" in descriptor) descriptor.writable = true;
            	Object.defineProperty(target, descriptor.key, descriptor);
        	}
    	}
    	return function(Constructor, protoProps, staticProps) {
        	if (protoProps) defineProperties(Constructor.prototype, protoProps);
        	if (staticProps) defineProperties(Constructor, staticProps);
        	return Constructor;
    	};
	}();
