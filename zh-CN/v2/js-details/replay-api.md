# 回放

在教育领域中，上完课之后往往需要记录板书让学生可以复习使用；在会议场景下，会后也需要发出完整的会议记录来帮助后面执行讨论的成果。

为了更好的满足客户对回放的需求，我们在云端提供的白板回放的录制功能，客户再也不用花费高昂的人力物力去手动录制成视频来提供回放功能。

并且相比传统的录制方式，我们的『白板回放加音频回放』的组合方案具备诸多优势如下：

- 高清播放、低带宽占用。方便用流量观看、以及在校园网等网络环境不稳定的场景下观看。
- 观看时支持缩放操作（zoom in & zoom out），方便客户用手机等移动端设备观看。
- 支持在微信朋友圈、小程序等流量平台传播课程。
- 无需老师或者工作人员介入，自动在云端完成。


## 房间模式

房间有三种模式：临时房间、持久化房间、可回放房间。房间模式必须在创建时指定，一旦确定，将不可修改。这三种模式的特征如下。

|    模式    | 可持久化 | 可回放 |                            描述                            |
| :--------: | :------: | :----: | :--------------------------------------------------------: |
|  临时房间  |     ✘    |    ✘   |  仅临时存在的房间。房间无人状态持续一段时间后将自动释放。  |
| 持久化房间 |    ✓     |   ✘   |        即便房间将永久存在，除非调用 API 手动删除。         |
| 可回放房间 |    ✓     |   ✓    | 同「持久化房间」。并且房间所有内容将被自动录制，以供回放。 |

我们可以在创建房间时，在 body 中加入 ``mode`` 字段来指定房间模式。

> 如果创建房间时没有 ``mode`` 字段，房间将默认以「持久化」模式创建。

```javascript
var mode = 'transitory'; // 临时房间模式
var mode = 'persistent'; // 持久化房间模式
var mode = 'historied'; // 可回放房间模式

var url = 'https://cloudcapiv3.herewhite.com/room?token=' + miniToken;
var requestInit = {
    method: 'POST',
    headers: {
        "content-type": "application/json",
    },
    body: JSON.stringify({
        name: 'My Room',
        limit: 100,
        mode: mode, // 房间模式在这里体现
    }),
};
```

## 在客户端回放片段

白板的内容会被自动录制。所以你无需显式地调用「开始录制」和「结束录制」。你只需要确保房间被正确设置成「可回放模式」，则该房间的所有行为就会在服务端被自动记录下来。等到需要回放时，你只需准备好回放所需要的完整参数即可。

如下是回放需要的参数。

|    参数    |                      描述                       |            是否可选            |
| :--------: | :---------------------------------------------: | :----------------------------: |
| 房间 uuid  |    希望回放的房间的 uuid。必须是可回放模式。    |              必填              |
| 开始时间戳 | 回放的开始片段的事件，整数，Unix 时间戳（毫秒） | 若不填，则从房间创建时开始回放 |
|  持续时长  |            回放片段持续时长（毫秒）             | 若不填，则从持续到录制点最新点 |

准备好参数后，你需要构造一个 ``player`` 实例。

```javascript
var roomUUID = "..."; // 希望回放房间的 uuid，必须是可回放模式的房间
var beginTimestamp = ...; // 回放的开始片段的事件，整数，Unix 时间戳（毫秒）
var duration = ...; // 回放片段持续时长（毫秒）

var promise = whiteWebSdk.replayRoom({
    room: roomUUID
    beginTimestamp: beginTimestamp,
    duration: duration,
});
promise.then(function(player) {
    // 获取到 player 实例
})
```

获取到 ``player`` 实例后，你需要将 player 绑定到网页上。

```javascript
// 将其与 #whiteboard 节点绑定
player.bindHtmlElement(document.getElementById('whiteboard'));
```

如果你直接使用 ``white-react-sdk`` 来开发，可以使用如下代码直接渲染出播放器。

```javascript
import React from "react";

class App extends React.Component {
    render() {
        return <PlayerWhiteboard player={player}/>;
    }
}
```

之后，通过如下代码开始播放。

```javascript
player.seekToScheduleTime(0); // 从时间 0 开始
player.play(); // 播放
```

## 播放器的其他操作

你可以通过如下方法快进到特定时间点。``scheduleTime`` 是一个大于 0 的整数（毫秒），它不应该超过回放片段持续时间。

```javascript
player.seekToScheduleTime(scheduleTime);
```

你可以开始播放。

```javascript
player.play();
```

也可以暂停。

```javascript
player.pause();
```

当你不再使用该播放器实例时，可以停止它以释放资源。

```javascript
player.stop();
```

