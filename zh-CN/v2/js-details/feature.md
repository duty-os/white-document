## 切换教具

white-web-sdk 提供多种教具，我们可以通过修改 `memberState` 来切换当前的教具。例如，将当前教具切换成「铅笔」工具可以使用如下代码。

```javascript
room.setMemberState({
    currentApplianceName: "pencil",
});
```

可以通过如下代码获取当前房间的教具名称。

```javascript
room.state.memberState.currentApplianceName
```

white-web-sdk 提供如下教具。

| 名称 | 字符串 | 描述 |
| :--- | :--- | :--- |
| 选择 | selector | 选择、移动、放缩 |
| 铅笔 | pencil | 画出带颜色的轨迹 |
| 矩形 | rectangle | 画出矩形 |
| 椭圆 | ellipse | 画出正圆或椭圆 |
| 橡皮 | eraser | 删除轨迹 |
| 文字 | text | 编辑、输入文字 |

## 调色盘

通过如下代码可以修改调色盘的颜色。

```javascript
room.setMemberState({
    strokeColor: [255, 0, 0],
});
```

通过将 RGB 写在一个数组中，形如 [255, 0, 0] 来表示调色盘的颜色。

也可以根据如下代码获取当前调色盘的颜色。

```javascript
room.state.memberState.strokeColor
```

调色盘能影响铅笔、矩形、椭圆、文字工具的效果。

## 刷新白板的尺寸

当白板所在的 ``<div>`` 尺寸发生变化时（通常是窗口大小改变，或业务逻辑需要改变布局），**必须**通过如下方法通知 SDK。

```javascript
room.refreshViewSize();
```

在一般实践中，当浏览器窗口大小发生改变时，往往会改变白板所在 ``<div>`` 的尺寸。这时，需要使用如下代码保证业务逻辑能响应窗口改变事件。

```javascript
function onWindowResize() {
    room.refreshViewSize();
}
// 房间刚完成初始化时调用
window.addEventListener("resize", onWindowResize);

// 房间销毁后调用
window.removeEventListener("resize", onWindowResize);
```

## 插入图片

white-web-sdk 支持向当前白板页面中插入图片，首先调用 `方法1` ，传递 uuid，以及图片位置（大小，中心位置）信息。uuid 是一个任意字符串，保证在每次调用时，使用不同值即可。
然后通过服务器，或者本地上传至云存储仓库中，获取到要插入图片信息的网络地址，在调用 `方法2`, 传入图片网络地址。

```JavaScript
// 方法1 插入图片占位信息
room.insertImage({
                    uuid: uuid,
                    centerX: x,
                    centerY: y,
                    width: imageFile.width,
                    height: imageFile.height,
                });
// 方法2 传入图片占位 uuid，以及图片网络地址。
room.completeImageUpload(uuid, imageUrl)
```

## 跟随演讲者的视角

white-web-sdk 提供的白板是向四方无限延生的。同时也允许用户通过鼠标滚轮、手势等方式移动白板。因此，即便是同一块白板的同一页，不同用户的屏幕上可能看到的内容是不一样的。

为此，我们引入「演讲者模式」这个概念。演讲者模式将房间内的某一个人设为演讲者，他/她屏幕上看到的内容即是其他所有人看到的内容。当演讲者进行视角的放缩、移动时，其他人的屏幕也会自动进行放缩、移动。

演讲者模式中，演讲者就好像摄像机，其他人就好像电视机。演讲者看到的东西会被同步到其他人的电视机上。

可以通过如下方法修改当前视角的模式。

```javascript
// 演讲者模式
// 房间内其他人的视角模式会被自动修改成 follower，并且强制观看你的视角。
// 如果房间内存在另一个演讲者，该演讲者的视角模式也会被强制改成 follower。
// 就好像你抢了他/她的演讲者位置一样。
room.setViewMode("broadcaster");

// 自由模式
// 你可以自由放缩、移动视角。
// 即便房间里有演讲者，演讲者也无法影响你的视角。
room.setViewMode("freedom");

// 追随模式
// 你将追随演讲者的视角。演讲者在看哪里，你就会跟着看哪里。
// 在这种模式中如果你放缩、移动视角，将自动切回 freedom模式。
room.setViewMode("follower");
```

我们也可以通过如下方法获取当前视角的状态。

```javascript
room.state.broadcastState
```

它的结构如下。

```typescript
export type BroadcastState = {

    // 当前视角模式，有如下：
    // 1."freedom" 自由视角，视角不会跟随任何人
    // 2."follower" 跟随视角，将跟随房间内的演讲者
    // 2."broadcaster" 演讲者视角，房间内其他人的视角会跟随我
    mode: ViewMode;

    // 房间演讲者 ID。
    // 如果当前房间没有演讲者，则为 undefined
    broadcasterId?: number;
};
```

## 视角中心

同一个房间的不同用户各自的屏幕尺寸可能不一致，这将导致他们的白板都有各自不同的尺寸。实际上，房间的其他用户会将白板的中心对准演讲者的白板中心（注意演讲者和其他用户的屏幕尺寸不一定相同）。

我们需要通过如下方法设置白板的尺寸，以便演讲者能同步它的视角中心。

```
room.setViewSize(1024, 768);
```

尺寸应该和白板在网页中的实际尺寸相同（一般而言就是浏览器页面的尺寸）。如果用户调整了窗口大小导致白板尺寸改变。应该重新调用该方法刷新尺寸。

## 面板操作开关

你可以通过 `room.disableOperations = true` 来禁止用户操作白板。

你可以通过 `room.disableOperations = false` 来恢复用户操作白板的能力。

## 缩放

一方面通过手势可以放缩白板，另一方面也可以通过调用 `zoomChange` 来缩放白板。

```javascript
room.zoomChange(10)
```

## 显示用户鼠标信息

* 在 `2.0.0-beta6` 中，新增了传递用户鼠标/手势信息的功能。

### 传入用户信息

在调用 sdk `joinRoom` API 时，额外传入 `userPayload` 字段。其中 userId 应为唯一值，否则，同一个 userid，先加入房间的用户会被后来的用户踢出房间。
具体字段为下面配置:

```Typescript
export type UserPayload = {
    //id 为遗留值，直接填0即可
    readonly id: number;
    readonly nickName: string;
    readonly avatar?: string;
    readonly userId: string;
};
```

### 读取用户信息

该信息会保存在 `room.state.roomMembers` 中， roomMembers 为数组，其中元素为以下格式。

```Typescript
export type RoomMember = {
    readonly memberId: number;
    readonly isRtcConnected: boolean;
    readonly information?: MemberInformation;
};
```

传入的 UserPayload 会对应转换在 `RoomMember` 的 `information` 字段中。memberId 则是 sdk 服务器，根据用户加入顺序分配的一个递增数字。

### 更新用户头像信息

当用户进行移动时，sdk 会回调创建 sdk 时，传入的 `onCursorViewsUpdate` 方法。

```Typescript
export type CursorUpdateDescription = {
    appearSet: CursorView[];
    disappearSet: CursorView[];
    updateSet: CursorView[];
};

export type CursorView = {
    readonly memberId: number;
    readonly x: number;
    readonly y: number;
};

```

该回调方法会返回一个 `CursorUpdateDescription` 结构。里面的用户信息，分为三种，分别为：出现的用户信息集合，消息的用户信息集合，更新的用户信息集合。

每个用户信息的具体内容，都在 `CursorView` ，可以根据 `memberId` 从 `room.state.roomMembers` 查找到对应的用户信息。

`x,y` 则是，该用户在白板上的位置。该坐标点的坐标原点，为白板左上角。x，y 则为用户坐标点距离白板左上角的位置。对应的，白板右下角坐标点，x，y 数值，即为白板的宽高。

推荐实现思路：在白板 div 之上，盖一层同样大小的 div，将 用户头像放在该 div 上。

以下为可以使用的 less 文件

```less
//覆盖在白板之上的 div
.user-cursor-layout {

  pointer-events: none;

  z-index: 4;
  position: absolute;
  top: 0;
  bottom: 0;
  left: 0;
  right: 0;

  > * {
    position: absolute;
  }
}

//用户头像
.user-cursor-inner {
  width: 32px;
  height: 32px;
  border-radius: 50%;
}

//用户图片
.user-cursor-img {
  width: 28px;
  height: 28px;
  border-radius: 14px;
  margin: 2px;
}

.user-cursor-tool {
  width: 16px;
  height: 16px;
  position: absolute;
  border-radius: 8px;
  border: 1px solid #FFFFFF;
  box-sizing: border-box;
  margin-top: -14px;
  margin-left: 16px;
  z-index: 10;
  display: flex;
  justify-content: center;
  align-items: center;
}
```

### 主动延时

1.x 不提供该 API， `2.0.0-beta.7` 新增API。

```JavaScript
//延时 1 秒播放
room.timeDelay = 1000;
//获取白板主动延时时间
let delay = room.timeDelay;
```

使用 `room.timeDelay` 方法，可以快速设置白板延时，可以人为给白板增加一部分延时，延迟播放。

注意点：

1. 参数单位为毫秒。
1. 该方法只对本地客户端有效。
1. 该方法会同时影响自定义时间，用户头像回调事件。
1. 用户本地绘制，仍然会实时出现。

## 清屏 API

* 2.0.0-beta.6 及其后续版本提供

```Java
/**
 清除当前屏幕内容

 @param retainPPT 是否保留 ppt
 */
let retainPpt = true;
room.cleanCurrentScene(retainPpt);
```