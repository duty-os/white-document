# JavaScript 快速开始

Hi, 亲爱的开发者，欢迎使用 White 白板。本教程将引导你在自己的网站中引入一块互动白板。不过首先，我们假定你已经了解 JavaScript 的基础语法，并掌握了 HTML 页面的基础知识。



# 创建项目

首先，你需要在你桌面端创建一个文件夹，作为工作空间。随后，我们将在这个工作空间中添加一些文件。然后，我们创建一个名为 `index.html` 的文件。
```html
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="https://sdk.herewhite.com/white-web-sdk/1.2.0.css">
        <script src="https://sdk.herewhite.com/white-web-sdk/1.2.0.js"></script>
        <script src="index.js"></script>
    </head>
    <body>
        <div id="whiteboard" style="width: 100%; height: 100vh;"></div>
    </body>
</html>
```

# 引入资源

该页面引用了 3 个 JavaScript 资源文件。

* [https://sdk.herewhite.com/white-web-sdk/1.2.0.css](https://sdk.herewhite.com/white-web-sdk/1.2.0.css)：White 的样式文件。
* [https://sdk.herewhite.com/white-web-sdk/1.2.0.js](https://sdk.herewhite.com/white-web-sdk/1.2.0.js)： White 的 SDK 文件。
* `index.js` ：这是实现我们业务逻辑的 js 文件。

# 创建白板

现在，我们在工作空间创建 `index.js` 文件。

```javascript
var whiteWebSdk = new WhiteWebSdk();
var miniToken = 'WHITEcGFydG5lcl9pZD1DYzlFNTJhTVFhUU5TYmlHNWJjbkpmVThTNGlNVXlJVUNwdFAmc2lnPTE3Y2ZiYzg0ZGM5N2FkNDAxZmY1MTM0ODMxYTdhZTE2ZGQ3MTdmZjI6YWRtaW5JZD00JnJvbGU9bWluaSZleHBpcmVfdGltZT0xNTY2MDQwNjk4JmFrPUNjOUU1MmFNUWFRTlNiaUc1YmNuSmZVOFM0aU1VeUlVQ3B0UCZjcmVhdGVfdGltZT0xNTM0NDgzNzQ2Jm5vbmNlPTE1MzQ0ODM3NDYzMzYwMA';

var url = 'https://cloudcapiv3.herewhite.com/room?token=' + miniToken;
var requestInit = {
    method: 'POST',
    headers: {
        "content-type": "application/json",
    },
    body: JSON.stringify({
        name: 'my whiteboard',
        limit: 100, // 房间人数限制
    }),
};

fetch(url, requestInit)
    .then(function(response) {
        return response.json();
    })
    .then(function(json) {
        return whiteWebSdk.joinRoom({
            uuid: json.msg.room.uuid,
            roomToken: json.msg.roomToken,
        });
    })
    .then(function(room) {
        room.bindHtmlElement(document.getElementById('whiteboard'));
    });
```

# 使用体验

这时，你的工作空间里应该已经创建了 2 个文件。
* index.html
* index.js

双击 `index.html` 或在浏览器（推荐使用 Chrome）地址栏中输入 `index.html` 的绝对路径，打开这个网页。


![demo-1.png | center | 747x474](https://cdn.nlark.com/yuque/0/2018/png/103701/1534488195953-bff8dedb-4acb-4451-b9d8-7820b895b449.png "")

之后，可以在网页上写写画画，此时应该能看到涂写的笔迹。至此，我们的第一个白板应用就做好了。


![demo-2.png | center | 747x474](https://cdn.nlark.com/yuque/0/2018/png/103701/1534488267047-bc949158-3c4d-4b7d-9ba0-f4c6f210b5e3.png "")


# 相关代码

你可以在 [Github](https://github.com/duty-os/white-demo-web/tree/master/quickStart) 上下载这章的所有代码。

