# 自定义事件与外部输入设备

## 自定义事件

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

## 外部输入设备 API

**注意点**

1. 该 API 并不稳定，有特殊需求的用户，可以使用该系列 API，目前不保证向后兼容。
2. **调用该 API 前，需要将白板设置为只读模式（`room.disableOperations = true`）**
3. 该 API 适用于画笔教具，无法用于选择教具；其他教具无法保证效果。

部分情况下，会有调用者自行传入触碰事件的需求。这里提供以下方法，允许将触碰事件转换为鼠标移动事件。

```Javascript
//等同于按下鼠标事件
externalDeviceEventDown(event: RoomMouseEvent): void;
//等同于鼠标移动事件
externalDeviceEventMove(event: RoomMouseEvent): void;
//等同于鼠标抬起事件
externalDeviceEventUp(event: RoomMouseEvent): void;
//等同于鼠标离开操作，可以认为类似鼠标抬起事件
externalDeviceEventLeave(event: RoomMouseEvent): void;
```

通过以上 API，sdk 本身会将用户传入的事件，转换为内部鼠标移动事件。

```typescript
export type RoomMouseEvent = {
    x: number;
    y: number;
    targetsMap: TargetsMap;
};
```

x，y 坐标原点为白板页面左上角。白板的宽高设置最好与外部设备一致。
targetsMap 直接传入 `{}` 即可。