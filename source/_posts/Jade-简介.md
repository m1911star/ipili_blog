---
title: Jade 简介（一）
date: 2016-07-18 12:59:03
tags:
  - Jade
  - Web
  
---

Jade是一款高性能简洁易懂的模板引擎，Jade是Haml的Javascript实现，在服务端（NodeJS）及客户端均有支持。
<!-- more -->
## 基本语法

1. 标签属性
	
		a(class='button', href='google.com') Google
		
		转换为HTML
		
		<a href="google.com" class="button">Google</a>
		
	与html语法类似，将标签属性放在括号内，同时支持一般的Javascript表达式，如：
	
		- var authenticated = true
		body(class=authenticated ? 'authed' : 'anon')
		
		转换为HTML
		
		<body class="authed"></body>
2. 样式属性
	
	该属性可接受一个封装的style对象，如
		
		a(style={color: 'red', background: 'green'})
		
		转换为HTML
		
		<a style="color:red;background:green"></a>
		
3. 类属性

	类属性可以是定义的字符串，或者是一个类的list。
	
		- var classes = ['foo', 'bar', 'baz']
		a(class=classes)
		//- the class attribute may also be repeated to merge arrays
		a.bing(class=classes class=['bing'])
		
		转换为HTML
		
		<a class="foo bar baz"></a><a class="bing foo bar baz bing"></a>
		
	另外一种定义方法
		
		a.button
		
		<a class="button"></a>
		
	默认标签为div，所以定义div可简写为
		
		.content
		
		<div class="content"></div>
		
4. 扩展的自定义属性

	自定义的属性可以由关键字 **&attributes**
	
		div#foo(data-bar="foo")&attributes({'data-foo': 'bar'})
		
		<div id="foo" data-bar="foo" data-foo="bar"></div>	


			