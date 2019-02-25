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

In the [《JavaScript guide》](/en-uk/v2/js_detail_api.md), we mentioned that the first step should be to construct the `whiteWebSdk` object.

```javascript
import {WhiteWebSdk} from 'white-web-sdk';
const whiteWebSdk = new WhiteWebSdk();
```

# Display whiteboard on webpage

`white-react-sdk` provides `RoomWhiteboard` to specifically display the whiteboard, which is a `React.Component`. Before using it, you need to get the room object first.

```javascript
import {WhiteWebSdk} from 'white-web-sdk';

const whiteWebSdk = new WhiteWebSdk();
whiteWebSdk.joinRoom({uuid: uuid, roomToken: roomToken}).then(function(room) {
    // Get to room by parameter
});
```

After that, the whiteboard is displayed as follows.

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

Note the `style` attribute in `<RoomWhiteboard>`. Without it, the final whiteboard may collapse in a corner of the page. If you want to use css instead of the `style` attribute, you can write it as follows.

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
