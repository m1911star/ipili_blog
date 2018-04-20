---
title: Sortable 实际支持向上拖拽
date: 2018-04-20 16:48:51
tags:
  - Web
---

Sortable.js是一款轻量级的拖放排序列表的js插件（虽然体积小，但是功能很强大），[下载地址](https://github.com/RubaXa/Sortable) 。
<!--more-->
```javascript
var timeout = null;
Sortable.create($('#dashboard .bd')[0], {
  animation: 300,
  handle: '.widget-topbar',
  scrollSensitivity: 200,
  scrollSpeed: 10,
  scroll: true,
  sort: function(event, ui) {
    var currentScrollTop = $(window).scrollTop(),
        topHelper = ui.position.top,
        delta = topHelper - currentScrollTop;
    timeout = setTimeout(function() {
      $(window).scrollTop(currentScrollTop + delta);
    }, 5);
  },
  onEnd: function() {
    clearTimeout(timeout);
    me.updateOrders();
  }
});
```
