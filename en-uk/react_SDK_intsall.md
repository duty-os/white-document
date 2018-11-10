# Install using the package management tool

White's Web-side SDK has been released to npmjs.com. If your project uses tools such as npm or yarn to manage dependencies, just enter a few lines of commands and you can install our SDK into your project.

If your project is based on React development, you can install White's React SDK directly.

First open your terminal and then go to your project folder. Make sure that the folder contains the `package.json` file at this time. If you use npm, enter the following command.

```bash
npm install white-react-sdk --save
```

If you use yarn, enter the following command.

```bash
yarn add white-react-sdk
```

# TypeScript configuration

If you use TypeScript as your development language, you will need to do additional configuration. Otherwise you can skip this step.

`white-web-sdk` provides a `*.d.ts` file to indicate the type. You need to add the following to the `compilerOptions` property of the `tsconfig.json` file to introduce them.

```json
"paths": {
    "*" : ["node_modules/white-web-sdk/types/*"]
}
```

# Construct a whiteWebSdk object

在 [《JavaScript 进阶教程》](https://www.yuque.com/herewhite/sdk/advanced_generality_js) 中，我们提到，第一步应该构造出 </span><span data-type="color" style="color:rgb(38, 38, 38)"><code>whiteWebSdk</code></span><span data-type="color" style="color:rgb(38, 38, 38)"> 对象。</span>

```javascript
import {WhiteWebSdk} from 'white-web-sdk';
const whiteWebSdk = new WhiteWebSdk();
```

# 在网页上显示白板

`'white-react-sdk'` 提供了 `RoomWhiteboard` 来专门展示白板，这是一个 `React.Component` 。在使用它之前，你需要先获取 room 对象。

```javascript
import {WhiteWebSdk} from 'white-web-sdk';

const whiteWebSdk = new WhiteWebSdk();
whiteWebSdk.joinRoom({uuid: uuid, roomToken: roomToken}).then(function(room) {
    // 通过参数获取到 room
});
```

之后，通过如下方式展示出白板。

```javascript
import React from 'react';
import ReactDOM from "react-dom";
import {RoomWhiteboard} from 'white-react-sdk';

class App extends React.Component {

    render() {
        return <RoomWhiteboard room={room}
                               style={{width: '100%', height: '100vh'}}/>;
    }
}

ReactDOM.render(<App/>, document.getElementById('react-root');
```

注意 `<RoomWhiteboard>` 中的 `style` 属性，<span data-type="color" style="color:rgb(38, 38, 38)"><span data-type="background" style="background-color:rgb(255, 255, 255)">如果没有它，最终的白板可能蜷缩在网页的一个角落中。如果你希望使用 css 来代替 </span></span>`style`<span data-type="color" style="color:rgb(38, 38, 38)"><span data-type="background" style="background-color:rgb(255, 255, 255)"> 属性，可以写成如下形式。</span></span>

```javascript
render() {
    return <RoomWhiteboard room={room} className='whiteboard'/>;
}
```

```css
.whiteboard {
    width: 100%;
    height: 100vh;
}
```

# 安装 css 文件

White 的 SDK 附带了一个 css 文件，你将它正确引入你的项目中才能使用。

你可以在项目所在目录的 `node_modules/white-web-sdk/style/index.css` 找到它。你可以直接将它上传到静态服务器的资源文件夹中，或上传到对象存储中。然后在网页的 `<head>` 通过 URL 引入该 css 即可。

如果你使用了 `css-loader` 之类的插件，你可以在项目的 `index.js` 中的引入。

```javascript
import 'white-web-sdk/style/index.css';
```

或在你的 `index.css` 中引入。

```css
@import 'white-web-sdk/style/index.css';
```
