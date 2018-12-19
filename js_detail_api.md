# 状态管理

white-web-sdk 还提供多种工具，如选择器、铅笔、文字、圆形工具、矩形工具。同时还提供图片展示工具和 PPT 工具。这些功能的展现形式，关系到具体网页应用本身的交互设计、视觉风格。考虑到这一点，白板上没有直接提供这些 UI 组件。你只能通过程序调用的方式，来让白板使用这些功能。

对此，你可能有如下疑问：

* 我的 UI 组件已经做好了，我如何让 UI 组件的操作影响到白板的行为？
* 白板有哪些状态，我的 UI 组件如何监听、获取白板的状态？

本章将解决这 2 个问题。

# 白板状态

当你加入一个房间后，你可以获取和修改的房间状态有如下 3 个。

* __GlobalState__：全房间的状态，自房间创建其就存在。所有人可见，所有人可修改。
* __MemberState__：成员状态。每个房间成员都有独立的一份实例，成员加入房间时自动创建，成员离开房间时自动释放。成员只能获取、监听、修改自己的 MemberState。
* __BroadcastState__：视角状态，和主播模式、跟随模式相关。

这 3 个状态都是一个 key-value 对象。

你可以通过如下方式获取它们。

```javascript
var globalState = room.state.globalState;
var memberState = room.state.memberState;
var broadcastState = room.state.broadcastState;
```

其中 room 对象需要通过调用 `joinRoom` 方法获取，在之前的篇章中有说明，在此不再赘述。

这 2 个状态可能被动改变，比如 GlobalState 可能被房间其他成员修改。因此，你需要监听它们的变化。具体做法是，在调用 `joinRoom` 时带上回调函数。

```javascript
var callbacks = {
    onRoomStateChanged: function(modifyState) {
        if (modifyState.globalState) {
            // globalState 改变了
            var newGlobalState = modifyState.globalState;
        }
        if (modifyState.memberState) {
            // memberState 改变了
            var newMemberState = modifyState.memberState;
        }
        if (modifyState.broadcastState) {
            // broadcastState 改变了
            var broadcastState = modifyState.broadcastState;
        }
    },
};
room.joinRoom({uuid: uuid, roomToken: roomToken}, callbacks);
```

当你需要修改白板状态的时候，你可以使用如下方式修改。

```javascript
room.setGlobalState({...});
room.setMemberState({...});
```

你不需要在参数中传入修改后的完整 GlobalState 或 MemberState，只需要填入你希望更新的 key-value 对即可。如果你修改了 GlobalState，整个房间的人都会收到你的修改结果。

# GlobalState

```typescript
type GlobalState = {
    // 当前场景索引，修改它会切换场景
    currentSceneIndex: number;
};
```

# MemberState

```typescript
type MemberState = {

    // 当前工具，修改它会切换工具。有如下工具可供挑选：
    // 1. selector 选择工具
    // 2. pencil 铅笔工具
    // 3. rectangle 矩形工具
    // 4. ellipse 椭圆工具
    // 5. eraser 橡皮工具
    // 6. text 文字工具
    currentApplianceName: string;

    // 选择工具半径，越大选择工具越容易点选
    selectorRadius: number;

    // 线条的颜色，将 RGB 写在一个数组中。形如 [255, 128, 255]。
    strokeColor: [number, number, number];

    // 线条的粗细
    strokeWidth: number;

    // 文字的字号
    textSize: number;
};
```

# BroadcastState

```typescript
type BroadcastState = {

    // 当前视角模式，有如下：
    // 1."freedom" 自由视角，视角不会跟随任何人
    // 2."follower" 跟随视角，将跟随房间内的主播
    // 2."broadcaster" 主播视角，房间内其他人的视角会跟随我
    mode: ViewMode;

    // 房间主播 ID。
    // 如果当前房间没有主播，则为 undefined
    broadcasterId?: number;
};
```
# 白板生命周期

joinRoom 的回调函数不仅可以监听白板的行为状态，还可以监听白板的生命周期状态和异常原因，具体使用如下

```javascript
var callbacks = {
    onPhaseChanged: phase => {
		// 白板发生状态改变, 具体状态如下:
        // "connecting",
    	// "connected",
    	// "reconnecting",
    	// "disconnecting",
    	// "disconnected",
    },
    onDisconnectWithError: error => {
        // 出现连接失败后的具体错误
    },
    onKickedWithReason: reason => {
        // 被踢出房间的原因
    },
};
room.joinRoom({uuid: uuid, roomToken: roomToken}, callbacks);
```



# 切换教具

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

# 调色盘

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


white-web-sdk 允许多个页面。在房间初次创建时，只有一个空白页面。我们可以通过如下方法来插入/删除页面。

```javascript
// 插入新页面在指定 index
room.insertNewPage(index: number);

// 删除 index 位置的页面
room.removePage(index: number);
```

我们可以通过修改 globalState 来做到翻页效果。

```javascript
// 翻到第 4 页
var index = 3;

room.setGlobalState({
    currentSceneIndex: index,
});
```

注意，globalState 是整个房间所有人共用的。通过修改 globalState 的 currentSceneIndex 属性来翻页，将导致整个房间的所有人切换到该页。

white-web-sdk 还支持插入 PPT。插入的 PPT 将变成带有 PPT 内容的页面。我们需要先将 PPT 文件或 PDF 文件的每一页单独转化成一组图片，并将这组图片在互联网上发布（例如上传到某个云存储仓库中，并获取每一张图片的可访问的 URL）。

然后，将这组 URL 通过如下方法插入。

```javascript
room.pushPptPages([
    {src: "http://website.com/image-001.png", width: 1024, height: 1024},
    {src: "http://website.com/image-002.png", width: 1024, height: 1024},
    {src: "http://website.com/image-003.png", width: 1024, height: 1024},
]);
```

这个方法将在当前也后面插入 3 个带有 PPT 内容的新页面。

# 跟随演讲者的视角

white-web-sdk 提供的白板是向四方无限延生的。同时也允许用户通过鼠标滚轮、手势等方式移动白板。因此，即便是同一块白板的同一页，不同用户的屏幕上可能看到的内容是不一样的。

为此，我们引入「演讲者模式」这个概念。演讲者模式将房间内的某一个人设为演讲者，他/她屏幕上看到的内容即是其他所有人看到的内容。当演讲者进行视角的放缩、移动时，其他人的屏幕也会自动进行放缩、移动。

演讲者模式中，演讲者就好像摄像机，其他人就好像电视机。演讲者看到的东西会被同步到其他人的电视机上。

可以通过如下方法修改当前视角的模式。

```typescript
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

```typescript
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

# 视角中心

同一个房间的不同用户各自的屏幕尺寸可能不一致，这将导致他们的白板都有各自不同的尺寸。实际上，房间的其他用户会将白板的中心对准演讲者的白板中心（注意演讲者和其他用户的屏幕尺寸不一定相同）。

我们需要通过如下方法设置白板的尺寸，以便演讲者能同步它的视角中心。

```
room.setViewSize(1024, 768);
```

尺寸应该和白板在网页中的实际尺寸相同（一般而言就是浏览器页面的尺寸）。如果用户调整了窗口大小导致白板尺寸改变。应该重新调用该方法刷新尺寸。

# 自定义事件

房间内的任何成员都可以通过如下方法广播自定义事件。

```javascript
room.dispatchMagixEvent(event, payload);
```

其中 ``event`` 是事件名，必须是字符串，用于标示该事件的类型。``payload`` 是该事件附带的数据，房间内接收到该事件的同时，可以读取到。``payload`` 可以是任意 JavaScript 的 primitive 类型，以及不带嵌套结构的 plain object 或仅包含 plain object 的数组结构。

例如，如下形式的**发送事件**调用是合法的。

```javascript
room.dispatchMagixEvent("SendGift", {
    senderName: "ZhangJie",
    receiverName: "Lili",
    giftType: "Lamborghini",
    imageIds: [1273, 2653, 23, 17283],
    timestamp: 1541820428865,
});
```

如果你希望监听房间内其他人发的事件，可以通过如下方式添加事件监听器。

```javascript
room.addMagixEventListener(event, callback);
```

其中 ``event`` 是事件名，必须是字符串。``callback`` 是一个回调函数，当房间内接收到事件时会被回调。我们可以通过如下形式注册事件监听器。

```javascript
function onRecevieGift(eventObject) {
    console.log(eventObject.event); // 事件名称
    console.log(eventObject.payload); // 事件 payload
}
room.addMagixEventListener("SendGift", onRecevieGift);
```

当之前的那一段**发送事件**调用后，控制台将会打印出如下内容。

```json
SendGift
{
    "senderName": "ZhangJie",
    "receiverName": "Lili",
    "giftType": "Lamborghini",
    "imageIds": [1273, 2653, 23, 17283],
    "timestamp": 1541820428865,
},
```

此外，你还可以注销事件监听器。

```javascript
room.removeMagixEventListener(event, callback);
```

例如，你可以通过如下代码注销刚才注册的事件监听器。

```javascript
room.removeMagixEventListener("SendGift", onRecevieGift);
```

# 面板操作开关

你可以通过 `room.disableOperations = true` 来禁止用户操作白板。

你可以通过 `room.disableOperations = false` 来恢复用户操作白板的能力。

# 缩放

一方面通过手势可以放缩白板，另一方面也可以通过调用 `zoomChange` 来缩放白板。

```javascript
room.zoomChange(10)
```
