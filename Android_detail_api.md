# 我们的解决方案
* 提供一块容易集成同时又功能强大的实时互动白板。
* 白板提供灵活的扩展能力和二次开发能力，提供全平台（iOS、Android、Web、小程序） SDK 。

# 教具
## 切换教具

White SDK 提供多种教具，我们可以通过修改 `memberState` 来切换当前的教具。例如，将当前教具切换成「铅笔」工具可以使用如下代码。
```java
MemberState memberState = new MemberState();
memberState.setCurrentApplianceName("pencil");
room.setMemberState(memberState);
```
可以通过如下代码获取当前房间的教具名称。

```java
room.getMemberState(new Promise<MemberState>() {
    @Override
    public void then(MemberState memberState) {
        memberState.getCurrentApplianceName();
    }

    @Override
    public void catchEx(Exception t) {

    }
});
```

### White 提供如下教具

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
```java
MemberState memberState = new MemberState();
memberState.setStrokeColor(new int[]{255, 0, 0});
room.setMemberState(memberState);
```
通过将 RGB 写在一个数组中，形如 [255, 0, 0] 来表示调色盘的颜色。

也可以根据如下代码获取当前调色盘的颜色。
```java
room.getMemberState(new Promise<MemberState>() {
    @Override
    public void then(MemberState memberState) {
        memberState.getStrokeColor();
    }

    @Override
    public void catchEx(Exception t) {

    }
});
```
调色盘能影响铅笔、矩形、椭圆、文字工具的效果。

# 翻页与 PPT

White SDK 允许多个页面并在其中进行切换。在白板初次创建时，只有一个空白页面。我们可以通过如下方法来插入/删除页面。
```java
// 插入新页面在指定 index
room.insertNewPage(1);

// 删除 index 位置的页面
room.removePage(1);
```
我们可以通过修改 globalState 来做到翻页效果。
```java
GlobalState globalState = new GlobalState();
globalState.setCurrentSceneIndex(1);
room.setGlobalState(globalState);
```

注意，globalState 是整个房间所有人共用的。通过修改 globalState 的 currentSceneIndex 属性来翻页，将导致整个房间的所有人切换到该页。

White SDK 还支持插入 PPT。插入的 PPT 将变成带有 PPT 内容的页面。我们需要先将 PPT 文件或 PDF 文件的每一页单独转化成一组图片，并将这组图片在互联网上发布（例如上传到某个云存储仓库中，并获取每一张图片的可访问的 URL）。

然后，将这组 URL 通过如下方法插入。
```java
room.pushPptPages(new PptPage[]{
    new PptPage("http://website.com/image-001.png", 600d, 600d),
    new PptPage("http://website.com/image-002.png", 600d, 600d),
    new PptPage("http://website.com/image-003.png", 600d, 600d)
});
```
这个方法将在当前页之后插入 3 个带有 PPT 内容的新页面。
# 主播模式

## 跟随主播的视角
White SDK 提供的白板是向四方无限延伸的。同时也允许用户通过鼠标滚轮、手势等方式移动白板。因此，即便是同一块白板的同一页，不同用户的屏幕上可能看到的内容是不一样的。

为此，我们引入「主播模式」这个概念。主播模式将房间内的某一个人设为主播，他/她屏幕上看到的内容即是其他所有人看到的内容。当主播进行视角的放缩、移动时，其他人的屏幕也会自动进行放缩、移动。

主播模式中，主播就好像摄像机，其他人就好像电视机。主播看到的东西会被同步到其他人的电视机上。

可以通过如下方法修改当前视角的模式。
```java
// 主播模式
// 房间内其他人的视角模式会被自动修改成 follower，并且强制观看你的视角。
// 如果房间内存在另一个主播，该主播的视角模式也会被强制改成 follower。
// 就好像你抢了他/她的主播位置一样。
room.setViewMode(ViewMode.broadcaster);

// 自由模式
// 你可以自由放缩、移动视角。
// 即便房间里有主播，主播也无法影响你的视角。
room.setViewMode(ViewMode.freedom);

// 追随模式
// 你将追随主播的视角。主播在看哪里，你就会跟着看哪里。
// 在这种模式中如果你放缩、移动视角，将自动切回 freedom模式。
room.setViewMode(ViewMode.follower);
```
我们也可以通过如下方法获取当前视角的状态。

```java
room.getBroadcastState(new Promise<BroadcastState>() {
    @Override
    public void then(BroadcastState broadcastState) {
        showToast(broadcastState.getMode());
    }
    @Override
    public void catchEx(Exception t) {}
});
```

它的结构如下。
```java
public class BroadcastState {
    private ViewMode mode;
    private Long broadcasterId;
    private MemberInformation broadcasterInformation;
    
    ... getter/setter
}
```

## 视角中心
同一个房间的不同用户各自的屏幕尺寸可能不一致，这将导致他们的白板都有各自不同的尺寸。实际上，房间的其他用户会将白板的中心对准主播的白板中心（注意主播和其他用户的屏幕尺寸不一定相同）。

我们需要通过如下方法设置白板的尺寸，以便主播能同步它的视角中心。
```java
room.setViewSize(100, 100);
```
尺寸应该和白板在产品中的实际尺寸相同（一般而言就是浏览器页面或者应用屏幕的尺寸）。如果用户调整了窗口大小导致白板尺寸改变。应该重新调用该方法刷新尺寸。

# 白板的工具制作与状态管理
White SDK 还提供多种工具，如选择器、铅笔、文字、圆形工具、矩形工具。同时还提供图片展示工具和 PPT 工具。这些功能的展现形式，关系到具体网页应用本身的交互设计、视觉风格。考虑到这一点，白板上没有直接提供这些 UI 组件。你只能通过程序调用的方式，来让白板使用这些功能。

对此，你可能有如下疑问：

* 我的 UI 组件已经做好了，我如何让 UI 组件的操作影响到白板的行为？
* 白板有哪些状态，我的 UI 组件如何监听、获取白板的状态？

本章将解决这 2 个问题。

## 白板状态
当你加入一个房间后，你可以获取和修改的房间状态有如下 2 个。

* __GlobalState__：全房间的状态，自房间创建其就存在。所有人可见，所有人可修改。
* __MemberState__：成员状态。每个房间成员都有独立的一份实例，成员加入房间时自动创建，成员离开房间时自动释放。成员只能获取、监听、修改自己的 MemberState。
* __BroadcastState__：视角状态，和主播模式、跟随模式相关。

这 3 个状态都是一个 key-value 对象。

你可以通过如下方式获取它们。
```java
room.getGlobalState(new Promise<GlobalState>() {
    @Override
    public void then(GlobalState globalState) {}
    @Override
    public void catchEx(Exception e) {}
});
room.getMemberState(new Promise<MemberState>() {
    @Override
    public void then(MemberState memberState) {}
    @Override
    public void catchEx(Exception e) {}
});
room.getBroadcastState(new Promise<BroadcastState>() {
    @Override
    public void then(BroadcastState broadcastState) {}
    @Override
    public void catchEx(Exception t) {}
});
```
其中 room 对象需要通过调用 `joinRoom` 方法获取，在之前的篇章中有说明，在此不再赘述。

这 2 个状态可能被动改变，比如 GlobalState 可能被房间其他成员修改。因此，你需要监听它们的变化。具体做法是在 `WhiteSDK` 上注册监听器，可以注册 `RoomCallbacks`  或者 `AbstractRoomCallbacks` ，使用后者可以只覆盖感兴趣的回调方法。
```java
whiteSdk.addRoomCallbacks(new RoomCallbacks() {
    @Override
    public void onPhaseChanged(RoomPhase roomPhase) {}
    @Override
    public void onBeingAbleToCommitChange(boolean b) {}
    @Override
    public void onDisconnectWithError(Exception e) {}
    @Override
    public void onKickedWithReason(String s) {}
    @Override
    public void onRoomStateChanged(RoomState roomState) {}
    @Override
    public void onCatchErrorWhenAppendFrame(long l, Exception e) {}
});
```

当你需要修改白板状态的时候，你可以使用如下方式修改。
```java
MemberState memberState = new MemberState();
memberState.setStrokeColor(new int[]{99, 99, 99});
memberState.setCurrentApplianceName("rectangle");
room.setMemberState(memberState);
```
你不需要在参数中传入修改后的完整 GlobalState 或 MemberState，只需要填入你希望更新的 key-value 对即可。如果你修改了 GlobalState，整个房间的人都会收到你的修改结果。

## GlobalState
```java
public class GlobalState {
    // 当前场景索引，修改它会切换场景
    private Integer currentSceneIndex;
    ... setter/getter
}
```

## MemberState
```java
public class MemberState {
    // 当前工具，修改它会切换工具。有如下工具可供挑选：
    // 1. selector 选择工具
    // 2. pencil 铅笔工具
    // 3. rectangle 矩形工具
    // 4. ellipse 椭圆工具
    // 5. eraser 橡皮工具
    // 6. text 文字工具
    private String currentApplianceName;
    // 线条的颜色，将 RGB 写在一个数组中。形如 [255, 128, 255]。
    private int[] strokeColor;
    // 线条的粗细
    private Double strokeWidth;
    // 文字的字号
    private Double textSize;
    ... setter/getter
}
```

## BroadcastState
```java
public class BroadcastState {
    // 当前视角模式，有如下：
    // 1."freedom" 自由视角，视角不会跟随任何人
    // 2."follower" 跟随视角，将跟随房间内的主播
    // 2."broadcaster" 主播视角，房间内其他人的视角会跟随我
    private ViewMode mode;

    // 房间主播 ID。
    // 如果当前房间没有主播，则为 undefined
    private Long broadcasterId;

    // 主播信息，可以自定义，具体参见下面的数据结构
    private MemberInformation broadcasterInformation;
    ... setter/getter
}

public class MemberInformation {
    // ID
    private Long id;
    // 昵称
    private String nickName;
    // 头像 URL
    private String avatar;
    ... setter/getter
}
```
# 

