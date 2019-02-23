# 使用包管理工具安装

White 的 Web 端 SDK 已经发布到了 npmjs.com。如果你的项目使用 npm 或 yarn 等工具来管理依赖包，仅仅输入几行命令，你就可以把我们的 SDK 安装到项目中。

首先打开你的终端，然后进入到你的项目文件夹中。请确保此时文件夹中包含了 `package.json` 这个文件。如果你使用 npm，输入如下命令。

```bash
npm install white-web-sdk@^1.0 --save
```

如果你使用 yarn，输入如下命令。

```bash
yarn add white-web-sdk@^1.0
```

# 通过 CDN 安装

```html
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="https://sdk.herewhite.com/white-web-sdk/1.3.7.css">
        <script src="https://sdk.herewhite.com/white-web-sdk/1.3.7.js"></script>
    </head>
    <body>
        <div id="whiteboard" style="width: 100%; height: 100vh;"></div>
    </body>
</html>

```

# 在 JavaScript 项目中使用

在[《JavaScript 进阶教程》](./concept.md)中，我们提到，第一步应该构造出 `whiteWebSdk` 对象。如果我们使用 npm 或 yarn 安装了 `'white-web-sdk'` ，可以使用如下代码构造出它。
```javascript
var WhiteWebSdk = require('white-web-sdk').WhiteWebSdk;
var whiteWebSdk = new WhiteWebSdk();
```

# 在 ES6 项目中使用

ES6 是 ECMAScript 6 的缩写。我们可以通过如下代码构造出 `whiteWebSdk` 对象。
```javascript
import {WhiteWebSdk} from 'white-web-sdk';
const whiteWebSdk = new WhiteWebSdk();
```

# 在 TypeScript 中使用

`'white-web-sdk'` 提供了 `*.d.ts` 文件来标明类型。你需要在 `tsconfig.json` 文件的 <span data-type="color" style="color:rgb(36, 41, 46)"><span data-type="background" style="background-color:rgba(27, 31, 35, 0.0470588)"><code>compilerOptions </code></span></span> 属性下添加如下内容来引入它们。
```json
"paths": {
    "*" : ["node_modules/white-web-sdk/types/*"]
}
```

之后，我们可以通过如下代码构造出 `whiteWebSdk` 对象。
```typescript
import {WhiteWebSdk} from 'white-web-sdk';
const whiteWebSdk: WhiteWebSdk = new WhiteWebSdk();
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
