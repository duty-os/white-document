# 使用包管理工具安装

<span data-type="color" style="color:rgb(38, 38, 38)"><span data-type="background" style="background-color:rgb(255, 255, 255)">White 的 Web 端 SDK 已经发布到了 npmjs.com。如果你的项目使用 npm 或 yarn 等工具来管理依赖包，仅仅输入几行命令，你就可以把我们的 SDK 安装到项目中。</span></span>

如果你的项目基于 React 开发，你可以直接安装 White 的 React SDK。

<span data-type="color" style="color:rgb(38, 38, 38)"><span data-type="background" style="background-color:rgb(255, 255, 255)">首先打开你的终端，然后进入到你的项目文件夹中。请确保此时文件夹中包含了 </span></span>`package.json`<span data-type="color" style="color:rgb(38, 38, 38)"><span data-type="background" style="background-color:rgb(255, 255, 255)"> 这个文件。如果你使用 npm，输入如下命令。</span></span>
```bash
npm install white-react-sdk@^1.0 --save
```

<span data-type="color" style="color:rgb(38, 38, 38)"><span data-type="background" style="background-color:rgb(255, 255, 255)">如果你使用 yarn，输入如下命令。</span></span>
```bash
yarn add white-react-sdk@^1.0
```

# TypeScript 的配置
如果你使用 TypeScript 作为开发语言，你还需要做额外的配置。否则你可以跳过这个步骤。

`'white-web-sdk'`<span data-type="color" style="color:rgb(38, 38, 38)"><span data-type="background" style="background-color:rgb(255, 255, 255)"> 提供了 </span></span>`*.d.ts`<span data-type="color" style="color:rgb(38, 38, 38)"><span data-type="background" style="background-color:rgb(255, 255, 255)"> 文件来标明类型。你需要在 </span></span>`tsconfig.json`<span data-type="color" style="color:rgb(38, 38, 38)"><span data-type="background" style="background-color:rgb(255, 255, 255)"> 文件的 </span></span><span data-type="color" style="color:rgb(36, 41, 46)"><span data-type="background" style="background-color:rgba(27, 31, 35, 0.0470588)"><code>compilerOptions </code></span></span><span data-type="color" style="color:rgb(38, 38, 38)"><span data-type="background" style="background-color:rgb(255, 255, 255)"> 属性下添加如下内容来引入它们。</span></span>
```json
"paths": {
    "*" : ["node_modules/white-web-sdk/types/*"]
}
```

# 构造 whiteWebSdk 对象
<span data-type="color" style="color:rgb(38, 38, 38)"><span data-type="background" style="background-color:rgb(255, 255, 255)">在</span></span>[《JavaScript 进阶教程》](./concept.md)<span data-type="color" style="color:rgb(38, 38, 38)">中，我们提到，第一步应该构造出 </span><span data-type="color" style="color:rgb(38, 38, 38)"><code>whiteWebSdk</code></span><span data-type="color" style="color:rgb(38, 38, 38)"> 对象。</span>
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
