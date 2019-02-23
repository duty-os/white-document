# Install using the package management tool

White's Web-side SDK has been released to npmjs.com. If your project uses tools such as npm or yarn to manage dependencies, just enter a few lines of commands and you can install our SDK into your project.

First open your terminal and then go to your project folder. Make sure that the folder contains the `package.json` file at this time. If you use npm, enter the following command.

```bash
npm install white-web-sdk --save
```

If you use yarn, enter the following command.

```bash
yarn add white-web-sdk
```

# Installed via CDN

```html
<!DOCTYPE html>
<html>
    <head>
        <link rel="stylesheet" href="https://sdk.herewhite.com/white-web-sdk/1.3.1.css">
        <script src="https://sdk.herewhite.com/white-web-sdk/1.3.1.js"></script>
    </head>
    <body>
        <div id="whiteboard" style="width: 100%; height: 100vh;"></div>
    </body>
</html>

```

# Used in a JavaScript project

In [《JavaScript advanced tutorial》](./js_detail_api.md), we mentioned that the first step should be to construct the `whiteWebSdk` object. If we installed `'white-web-sdk'` with npm or yarn , we can construct it using the following code.

```javascript
var WhiteWebSdk = require('white-web-sdk').WhiteWebSdk;
var whiteWebSdk = new WhiteWebSdk();
```

# Used in ES6 projects

ES6 is an abbreviation for ECMAScript 6. We can construct the `whiteWebSdk` object with the following code.

```javascript
import {WhiteWebSdk} from 'white-web-sdk';
const whiteWebSdk = new WhiteWebSdk();
```

# Used in TypeScript

`white-web-sdk` provides a `*.d.ts` file to indicate the type. You need to add the following to the `compilerOptions` property of the `tsconfig.json` file to introduce them.

```json
"paths": {
    "*" : ["node_modules/white-web-sdk/types/*"]
}
```

After that, we can construct the `whiteWebSdk` object with the following code.

```typescript
import {WhiteWebSdk} from 'white-web-sdk';
const whiteWebSdk: WhiteWebSdk = new WhiteWebSdk();
```

# Install css file

White's SDK comes with a css file that you can use to properly import it into your project.

You can find it in the directory where the project is located at `node_modules/white-web-sdk/style/index.css`. You can upload it directly to the resource folder of the static server or upload it to the object store. Then introduce the css through the URL in the `<head>` of the web page.

If you use a plugin like `css-loader`, you can introduce it in the project's `index.js`.

```javascript
import 'white-web-sdk/style/index.css';
```

Or introduced in your `index.css`.

```css
@import 'white-web-sdk/style/index.css';
```
