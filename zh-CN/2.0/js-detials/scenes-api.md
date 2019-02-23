# JavaScript 场景管理

white-web-sdk 提供多场景管理，以便实现诸如 PPT 分页、插入多块白板等功能。每一个房间可以拥有一个或多个场景。每个场景彼此独立，房间同一时间只能切换到一个场景。

## 场景的路径与名字

每一个场景都有自己的名字和路径。如下是一组合法的场景路径。

- /physics/newtonian-mechanics
- /physics/relativity-theory
- /physics/quantum-mechanics
- /english/good-morning
- /english/it-is-ranning
- /english/how-do-you-do

路径以 ``/`` 符分割层级，且一定以 ``/`` 开始。最右边的层级就是场景的名字。

## 场景组

多个场景可以归于同一个「场景组」。通过观察上一节中的场景路径例子，我们发现可以通过如下路径描述 2 个场景组。

- /physics
- /english

例如，`/pyhsics` 场景组下有如下场景（按照路径列出）。

- /physics/newtonian-mechanics
- /physics/relativity-theory
- /physics/quantum-mechanics

> 如果你熟悉 Unix / Linux 的文件系统，你会发现路径的形式和它们很像。场景就像文件，场景组就像文件夹。我们推荐你这么想象。

## 当前场景

当前场景用来代表该房间此时此刻大家所看到的房间。当你新建一个新房间时，当前场景会被默认设置成 ``/init`` 。这是一个默认创建的空白场景。

你可以通过如下代码切换当前场景。

```typescript
// 其中，room 是你通过 whiteWebSdk.joinRoom(...) 获取的房间对象
// 该方法的参数为你象切换到的场景路径
room.setScenePath("/physics/relativity-theory");
```

如果这行代码报错，可能是如下因素导致的。

1. 路径不合法。请通过之前的章节确保场景路径符合规范。
2. 路径对应的场景不存在。
3. 路径对应的是场景组。注意场景组和场景是不一样的。

## 场景状态

你可以通过如下代码查看房间的场景状态。

```typescript
room.state.sceneState;
```

在上一小节中，我们通过 ``room.setScenePath("/physics/relativity-theory")`` 切换了当前场景。如果该方法调用成功，``room.state.sceneState`` 将返回如下值。

```typescript
{
    scenePath: "/physics/relativity-theory",
    scenes: [{
		name: "newtonian-mechanics",
        componentsCount: 0,
    }, {
		name: "relativity-theory",
        componentsCount: 0,
    }, {
		name: "quantum-mechanics",
        componentsCount: 0,
    }],
    index: 1,
}
```

我们来看看这个返回值。它的 ``scenePath`` 表示当前场景的地址。不出所料 ``"/physics/relativity-theory"`` 正式我们刚才切换时输入的。

``scenes`` 表示当前场景所在的场景组的所有场景。可以看到 ``scenes`` 包含了 /physics 下的所有场景。但是不包含 /english 下的场景，因为 /english 不是当前场景路径所在的场景组。

``index`` 表示当前场景在所在场景组中的索引位置。参考 ``scenes`` 我们发现 ``"relativity-theory"`` 在第 2 项，所以 ``index`` 的值是 1（索引从 0 开始记）。

## 删除场景

我们可以通过调用如下方法。传入场景路径，来删除特定场景。

```typescript
room.removeScenes("/physics/relativity-theory");
```

也可以通过传入场景组路径来删除某个场景组下的所有场景。

```typescript
room.removeScenes("/english");
```

上一行代码会删除如下所有场景。

- /english/good-morning
- /english/it-is-ranning
- /english/how-do-you-do

你也可以通过直接删除根场景组，来清空整个房间的所有场景。

```typescript
room.removeScenes("/");
```

这时你会发现整个房间仅剩下一个名为 /init 的场景。

> White 必须保证房间内至少存在一个场景。因此，当你删光房间里的最后一个场景时，会立即自动生成一个名为 /init 的空白场景。

## 插入场景

你可以通过如下方法插入一个场景。

```typescript
room.putScenes("/math", [{name: "geometry"}]);
```

这会在 /math 场景组下创建一个路径为 /math/geometry 的空白场景。

你也可以不填写 ``name`` 。

```typescript
room.putScenes("/math", [{name: undefined}]);
```

这样，新场景的 ``name`` 会自动填写成一个 uuid。这将会在 /math 场景组下创建一个路径为形如 /math/e626435392ad484b96b57204e5699ea0 的空白场景。

你可以通过如下代码在特定场景组下一次行插入一组场景。

```typescript
var scenesArray = [
    {name: "algebra"},
    {name: "matrix"},
    {name: "arithmetic"},
];
room.putScenes("/math", [{name: undefined}]);
```

执行完以上所有代码后，房间内拥有的所有场景的路径如下。

- /math/geometry
- /math/e626435392ad484b96b57204e5699ea0
- /math/algebra
- /math/matrix
- /math/arithmetic
- /init

我们发现，场景组内场景的排列顺序就是我们插入的顺序。这意味着我们每次插入的场景都会自动排在场景组的末尾。如果我们希望将场景插入到特定位置，可以通过如下代码实现。

```typescript
var index = 1;
room.putScenes("/math", [{name: "I-am-the-second"}], index);
```

执行完如上代码后，房间内拥有的所有场景的路径如下。

- /math/geometry
- **/math/I-am-the-second**
- /math/e626435392ad484b96b57204e5699ea0
- /math/algebra
- /math/matrix
- /math/arithmetic
- /init

##  移动、重命名场景

你可以通过如下代码将一个场景移动到另外一个场景组。

```typescript
room.moveScene("/math/geometry", "/graphics/geometry");
```

执行完如上代码后，房间内拥有的所有场景的路径如下。

- /math/I-am-the-second
- /math/e626435392ad484b96b57204e5699ea0
- /math/algebra
- /math/matrix
- /math/arithmetic
- **/graphics/geometry**
- /init

你可以通过如下代码给一个场景重命名。

```typescript
room.moveScene("/math/arithmetic", "/graphics/SuanShu");
```

- /math/I-am-the-second
- /math/e626435392ad484b96b57204e5699ea0
- /math/algebra
- /math/matrix
- **/math/SuanShu**
- /graphics/geometry
- /init

你也可以通过如下代码调整场景的排列顺序。

```typescript
var = 0;
room.moveScene("/math/SuanShu", "/graphics/SuanShu", index);
```

- **/math/SuanShu**
- /math/I-am-the-second
- /math/e626435392ad484b96b57204e5699ea0
- /math/algebra
- /math/matrix
- /graphics/geometry
- /init

## 路径的唯一性

同一个路径在房间中可以唯一定位场景。这意味着场景的路径是排他的。你无法让两个场景拥有相同的路径。假设房间内已经存在如下场景 /math/algebra。当你使用如下场景插入一个新的空白场景时。

```typescript
room.putScenes("/math", [{name: "algebra"}]);
```

你的新的空白的 /math/algebra 场景会覆盖旧的场景。这意味着如果旧的 /math/algebra 场景上涂写了内容，这些内容将会被覆盖。

房间内，场景的路径不可以与场景组的路径相同。例如，房间内已经存在如下场景 /math/algebra。当你使用如下场景插入一个新的空白场景时。

```typescript
room.putScenes("/", [{name: "math"}]);
```

如上代码会报错。因为你试图插入一个路径为 /math 的场景，由于房间内还存在路径为 /math/algebra 的场景，这意味着房间内一定存在一个名为 /math 的场景组。

如果你一定要插入一个路径为 /math 的场景，你必须先使用如下代码删除 /math 场景组下的所有场景，以确保房间内不再存在 /math 的场景组才行。

```typescript
room.removeScenes("/math");
```

## 插入 PPT 与 PPT 的分组管理

如果你希望通过白板来演示 PPT，可以以如下思路设计业务。首先，你需要通过某种服务将 PPT 文件转化成一组图片，并将这一组图片存在云端。这时，你能拿到一组图片的 URL。

然后，你可以在房间里插入一组场景，让场景与这一组 PPT 的图片的 URL 一一对应。将场景的背景设置成它对应的图片 URL。这一步骤你可以通过如下代码一步到位。

```typescript
room.putScenes("/ppt", [
    {ppt: "https://cloud-oss.com/ppt/1.png"},
    {ppt: "https://cloud-oss.com/ppt/2.png"},
    {ppt: "https://cloud-oss.com/ppt/3.png"},
    {ppt: "https://cloud-oss.com/ppt/4.png"},
]);
```

如果你想在同一个房间内展示多个 PPT 文件，你可以为每个 PPT 文件分配不同的场景组。

你可以通过如下方法获取当前 PPT 文件的所有页的列表。

```typescript
room.state.sceneState.scenes;
```

由于你将不同的 PPT 文件分配在不同场景组，因此，这个列表仅仅展示当前 PPT 的页列表。你可以通过这些信息构造 PPT 的侧边栏。

## 插入PPT 与插入图片的区别

| 区别           | 插入PPT                                                      | 插入图片                                                     |
| -------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| 调用后结果     | 会自动新建多个白板页面，但是仍然保留在当前页（所以无明显区别），需要通过翻页API进行切换 | 产生一个占位界面，插入真是图片，需要调用 `completeImageUploadWithUuid:src` ,传入占位界面的 uuid，以及图片的网络地址 |
| 移动           | 无法移动，所以不需要位置信息                                 | 可以移动，所以插入时，需要提供图片大小以及位置信息           |
| 与白板页面关系 | 插入 ppt 的同时，白板就新建了一个页面，这个页面的背景就是 PPT 图片 | 是当前白板页面的一部分，同一个页面可以加入多张图片           |