# 从 v1.0 迁移 到 v2.0

现在，v2.0 支持录制与回放功能。今后，v2.0 将是我们的主推版本。我们会持续不断为 v2.0 开发更多的功能。如果你还在使用 v1.0，不必担心，我们不会关闭 v1.0 的服务。但我们依然推荐你迁移到 v2.0。

## 注意事项

在你决定迁移到 v.2.0 之前，请务必了解如下注意事项。

- v2.0 的房间与 v1.0 的房间是不互通的。这意味着你通过 v1.0 的 API 创建的房间，在 v2.0 环境下是不可见的。反之亦然。
- v2.0 对 API 进行了调整。当你将 SDK 升级到 v2.0 时，你可能发现你的代码无法通过编译了。不过不必担心，参照本章节，我们会教你如何一步一步修改代码直到支持 v2.0。
- 你可能发现 v2.0 的某些 API 被废弃了。不必担心，我们并没有将 v1.0 的任何功能撤销。它们只不过在 v2.0 中以另一种形式存在。所以不必担心你的业务代码依赖的功能没了。本章节会教你如何恢复这些功能。
- 服务端的 API 域名发生了调整。你需要调整业务服务器的代码，以确定调用的是 v2.0 的 API，而非 v1.0 的 API。

## pptImages 不见了

你可能发现你的如下代码导致运行时报错。

```javascript
var pptImages = room.state.pptImages; // pptImages is undefined
```

那是因为我们的新版 API 中直接暴露场景，而非用一个字符串数组表示 PPT 内容。将你的代码替换成如下形式即可。

```javascript
var pptImages = room.state.sceneState.scenes.map(function(scene) {
    if (scene.ppt) {
        return scene.ppt.src;
    } else {
        return "";
    }
});
```

当然，我们更推荐你直接抛弃 pptImages 这个概念，重构代码，通过直接管理场景来处理与 PPT 相关的业务。

```javascript
var scenes = room.state.sceneState.scenes;
```

建议你参考阅读[《JavaScript 场景管理》](./scenes-api.md) 了解场景相关的知识。

## scenes 不见了

你可能发现你的如下代码导致运行时报错。

```javascript
var scenes = room.state.scenes; // scenes is undefined
```

``scenes`` 被挪到了另一个位置。你可以改成如下形式。

```javascript
var scenes = room.state.sceneState.scenes;
```

## Scene 的结构变了。

你在之前可能会读取 Scene 的 ``key`` 字段，以满足自己的业务需求。但发现 ``key`` 永远是 ``undefined``。

```javascript
var scene = room.state.scenes[0];
var key = scene.key; // key is undefined
```

这是因为 v2.0 中，场景不再通过 ``key`` 字段来区分彼此。如上代码，你可以替换成如下形式。

```javascript
var scenes = room.state.sceneState.scenes;
var name = scene.name;
```

如果你之前将 ``key`` 视为场景的全局唯一标识符。那么现在我强烈建议你将场景的路径作为 ``key`` 的替代品。相关内容建议你参考阅读[《JavaScript 场景管理》](./scenes-api.md) 了解场景相关的知识。

你在之前可能会读取 Scene 的 ``isEmpty`` 字段，以满足自己的业务需求。但发现 ``isEmpty`` 永远是 ``undefined``。

```javascript
var scene = room.state.scenes[0];
var isEmpty = scene.isEmpty; // key is isEmpty
```

这是因为 v2.0 中，我们使用 ``componentsCount`` 直接告诉当前场景有多少元素。如上代码，你可以替换成如下形式。

```javascript
var scene = room.state.scenes[0];
var isEmpty = scene.componentsCount === 0;
```

## 读取和修改当前场景

你可能发现无法读取当前场景的索引。

```javascript
var index = room.state.globalState.currentSceneIndex; // index is undefined
```

这个索引被移到了另外一个地方。

```javascript
var index = room.state.sceneState.index;
```

然后，你会发现你不能通过如下方式修改索引。

```javascript
room.state.sceneState.index = index; // 错误
```

这是因为，在 v2.0 中，我们只能通过场景路径的方式修改当前场景。相关内容建议你参考阅读[《JavaScript 场景管理》](./scenes-api.md) 了解场景相关的知识。然后调整你的代码。

## 上传 PPT

你可能发现无法上传 PPT 了。

```javascript
var pptPages = [...];
room.pushPptPages(pptPages); // 运行时错误
```

你可以将代码替换成如下形式。

```javascript
var pptPages = [...];
room.putScenes("/", pptPages.map(page => ({ppt: page})));
```

建议你参考阅读[《JavaScript 场景管理》](./scenes-api.md) 了解场景相关的知识。

## 插入与删除场景

你可能发现，如下代码无法正确执行了。

```javascript
var index = 0;
room.insertNewPage(index); // 运行时错误
room.removePage(index); // 运行时错误
```

你可以将代码替换成如下形式。

```javascript
var index = 0;
room.putScenes('/', [{}], index);

var toRemoveScene = room.state.sceneState.scenes[index];
room.removeScene('/' + toRemoveScene.name);
```

建议你参考阅读[《JavaScript 场景管理》](./scenes-api.md) 了解场景相关的知识。