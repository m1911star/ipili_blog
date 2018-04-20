---
title: Websocket 初识
tags:
  - Web
  - WebSocket
date:
categories:
  - 技术
---

Websocket 是一种基于ws协议的技术，用于建立全双工连接 这使得在用户的浏览器和一个服务器之间打开一个的交互式通信会话成为可能, 有了这个API，你可以向服务器发送消息,并接收事件驱动的响应, 无需轮询服务器的响应。
<!-- more -->
### 例子

#### 初始化

```js
var exampleSocket = new Websocket("ws://www.example.com/socketserver", "protocolOne");
```

赋值之后， exampleSocket.readyState 会变成 CONNECTING。一旦连接建立，并可传输数据，这里的 readyState 会变成 OPEN。

#### 发送数据到服务器

```js
exampleSocket.send("Here's some text that the server is urgently awaiting!");
```

建立连接到过程是异步的，可以设置onopen函数作为回调.

```js
exampleSocket.onopen = function (event) {
  exampleSocket.send("亲爱的服务器！我连上你啦！");
};
```

使用JSON格式传递数据

```js
// 通过服务器向全体发言
function sendText() {
  // 创建一个 msg 对象，其中含有服务器需要处理的数据。
  var msg = {
    type: "message",
    text: document.getElementById("text").value,
    id:   clientID,
    date: Date.now()
  };

  // 将其作为 JSON 格式字符串发送。
  exampleSocket.send(JSON.stringify(msg));

  // 清空文本输入框
  document.getElementById("text").value = "";
}
```

#### 从服务器接收信息

WebSockets 是事件驱动 API。当有消息到来，会触发 "message" 事件，调用 onmessage 函数。要侦听服务器发来的消息，就像这样即可：

```js
exampleSocket.onmessage = function (event) {
  console.log(event.data);
}
```

#### 关闭连接

```js
exampleSocket.close();
```
