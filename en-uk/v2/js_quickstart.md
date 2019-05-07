# JavaScript quick start

Hi, Dear developer, welcome to the Whiteboard. This tutorial will guide you through the introduction of an interactive whiteboard on your website. But first, let's assume that you already understand the basic syntax of JavaScript and master the basics of HTML pages.



# Create project

First, you need to create a folder on your desktop as a workspace. We will then add some files to this workspace. Then we create a file called `index.html`.

```html
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="https://sdk.herewhite.com/white-web-sdk/1.3.1.css">
        <script src="https://sdk.herewhite.com/white-web-sdk/1.3.1.js"></script>
        <script src="index.js"></script>
    </head>
    <body>
        <div id="whiteboard" style="width: 100%; height: 100vh;"></div>
    </body>
</html>
```

# Introducing resources

This page references 3 JavaScript resource files.

* [https://sdk.herewhite.com/white-web-sdk/1.3.1.css](https://sdk.herewhite.com/white-web-sdk/1.3.1.css): White style file.
* [https://sdk.herewhite.com/white-web-sdk/1.3.1.js](https://sdk.herewhite.com/white-web-sdk/1.3.1.js): White SDK file.
* `index.js` : This is the js file that implements our business logic.

# Create a whiteboard

Now we create the `index.js` file in the workspace.

```javascript
var whiteWebSdk = new WhiteWebSdk();
var sdkToken = 'WHITEcGFydG5lcl9pZD1DYzlFNTJhTVFhUU5TYmlHNWJjbkpmVThTNGlNVXlJVUNwdFAmc2lnPTE3Y2ZiYzg0ZGM5N2FkNDAxZmY1MTM0ODMxYTdhZTE2ZGQ3MTdmZjI6YWRtaW5JZD00JnJvbGU9bWluaSZleHBpcmVfdGltZT0xNTY2MDQwNjk4JmFrPUNjOUU1MmFNUWFRTlNiaUc1YmNuSmZVOFM0aU1VeUlVQ3B0UCZjcmVhdGVfdGltZT0xNTM0NDgzNzQ2Jm5vbmNlPTE1MzQ0ODM3NDYzMzYwMA';

var url = 'https://cloudcapiv3.herewhite.com/room?token=' + sdkToken;
var requestInit = {
    method: 'POST',
    headers: {
        "content-type": "application/json",
    },
    body: JSON.stringify({
        name: 'my whiteboard',
        limit: 100, // Room size limit
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

# Use experience

At this point, you should have created 2 files in your workspace.

* index.html
* index.js

Open this page by double-clicking `index.html` or entering the absolute path of `index.html` in the address bar of your browser (recommended to use Chrome).


![demo-1.png | center | 747x474](https://cdn.nlark.com/yuque/0/2018/png/103701/1534488195953-bff8dedb-4acb-4451-b9d8-7820b895b449.png "")

After that, you can write and draw on the webpage, and you should be able to see the handwritten strokes. At this point, our first whiteboard application is ready.


![demo-2.png | center | 747x474](https://cdn.nlark.com/yuque/0/2018/png/103701/1534488267047-bc949158-3c4d-4b7d-9ba0-f4c6f210b5e3.png "")


# Related code

You can be at [Github](https://github.com/duty-os/white-demo-web/tree/master/quickStart) Download all the code for this chapter.

