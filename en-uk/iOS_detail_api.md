# Our solution

* 提供一块容易集成同时又功能强大的实时互动白板。
* 白板提供灵活的扩展能力和二次开发能力，提供全平台（iOS、Android、Web、小程序） SDK 。

# 白板的教具与状态

* 我的 UI 组件已经做好了，我如何让 UI 组件的操作影响到白板的行为？
* 白板有哪些状态，我的 UI 组件如何监听、获取白板的状态？

当你加入一个房间后，你可以获取和修改的房间状态主要有如下几种：
* __GlobalState__：全房间的状态，自房间创建其就存在。所有人可见，所有人可修改。
* __MemberState__：成员状态。每个房间成员都有独立的一份实例，成员加入房间时自动创建，成员离开房间时自动释放。成员只能获取、监听、修改自己的 MemberState。
* __BroadcastState__：视角状态，和主播模式、跟随模式相关。

事件通知API，可以在 `WhiteRoomCallbacks.h` 中查看。
设置状态与获取状态的API，可以在 `WhiteRoom.h` 中查看。
*每个主动设置API，会在后面附上需要查看的关键类。* 

## 教具列表

| 名称 | objective-C 常量 | 描述 |
| :--- | :--- | :--- |
| 选择 | ApplianceSelector | 选择、移动、放缩 |
| 铅笔 | AppliancePencil | 画出带颜色的轨迹 |
| 矩形 | ApplianceRectangle | 画出矩形 |
| 椭圆 | ApplianceEllipse | 画出正圆或椭圆 |
| 橡皮 | ApplianceEraser | 删除轨迹 |
| 文字 | ApplianceEraser | 编辑、输入文字 |

## 切换教具

* White SDK 提供多种教具，我们可以通过生成 `WhiteMemberState` 实例，来设置当前的教具。
* 例如，将当前教具，切换成「铅笔」工具，可以使用如下代码：

```objectivec
WhiteMemberState *memberState = [[WhiteMemberState alloc] init];
//白板初始状态时，教具默认为画笔pencil。
//可在 WhiteMemeberState.h 中看到当前提供的各种教具常量
memberState.currentApplianceName = AppliancePencil;
[whiteRoom setMemberState:memberState];
```

## 设置教具颜色，粗细
`WhiteMemberState` 还有其他属性:

```objectivec
@interface WhiteMemberState : WhiteObject
/** 传入格式为[@(0-255),@(0-255),@(0-255)]的RGB */
@property (nonatomic, copy) NSArray<NSNumber *> *strokeColor;
/** 画笔粗细 */
@property (nonatomic, strong) NSNumber *strokeWidth;
```

1. `strokeColor` 属性，可以调整教具的颜色。该属性，能够影响铅笔、矩形、椭圆、文字工具颜色。
2. `strokeWidth` 属性，可以调整教具粗细。该属性，能够影响铅笔、矩形、椭圆、文字工具颜色。

## 获取当前教具
```objectivec
[whiteRoom getMemberStateWithResult:^(WhiteMemberState *state) {
    NSLog(@"%@", [state jsonString]);
}];
```

## 订阅白板状态
参见 WhiteRoomCallbackDelegate

* 回调API列表：

```objectivec
@protocol WhiteRoomCallbackDelegate <NSObject>
/** 白板网络连接状态回调 */
- (void)firePhaseChanged:(WhiteRoomPhase)phase;
/** 白板当前任意RoomState属性变量变化时，回调 */
- (void)fireRoomStateChanged:(WhiteRoomState *)magixPhase;
- (void)fireBeingAbleToCommitChange:(BOOL)isAbleToCommit;
/** 白板失去连接回调，附带原因 */
- (void)fireDisconnectWithError:(NSString *)error;
/** 用户被远程服务器踢出房间，附带原因 */
- (void)fireKickedWithReason:(NSString *)reason;
/** 用户错误事件捕获 */
- (void)fireCatchErrorWhenAppendFrame:(NSUInteger)userId error:(NSString *)error;

@end
```

* 何时传入delegate？

在调用以下API生成SDK时，传入的 `callbacks` 参数，需要实现以上protocol。即可在事件发生时，接受回调。

```objectivec
- (void)joinRoomWithRoomUuid:(NSString *)roomUuid roomToken:(NSString *)roomToken callbacks:(id<WhiteRoomCallbackDelegate>)callbacks completionHandler:(void (^) (BOOL success, WhiteRoom *room, NSError *error))completionHander;
```

注意：<strong>调用 </strong><strong><code>WhiteRoom</code></strong><strong> API设置房间状态，也会触发事件回调。</strong>

# PPT与翻页
参考 WhitePptPage 和 WhiteGlobalState

## 插入PPT
White SDK 还支持插入 PPT。插入的 PPT 将变成带有 PPT 内容的页面。我们需要先将 PPT 文件或 PDF 文件的每一页单独转化成一组图片，并将这组图片在互联网上发布（例如上传到某个云存储仓库中，并获取每一张图片的可访问的 URL）。

```objectivec
WhitePptPage *pptPage = [[WhitePptPage alloc] init];
pptPage.src = @"https://www.xxx.com/1.png";
pptPage.width = 600;
pptPage.height = 600;
//始终是数组
[self.room pushPptPages:@[pptPage]];
```

*插入的PPT默认会在并非立刻显示，而是会自动新建多个白板页面，但是仍然保留在当前页，可以通过翻页API进行切换* 

## 获取 PPT
获取 PPT 会返回各个 PPT 图片的网址

```objectivec
[self.room getPptImagesWithResult:^(NSArray<NSString *> *pptPages) {
    NSLog(@"%@", pptPages);
}];
```

## 翻页
参考 WhiteGlobalState
PPT插入后，White SDK 会创建多个页面（默认仍然停留在当前页），并允许在其中进行切换。
在白板初次创建时，只有一个空白页面。我们可以通过如下方法来插入、删除、切换页面。

__注意，globalState 是整个房间所有人共用的。通过修改 globalState 的 currentSceneIndex 属性来翻页，将导致整个房间的所有人切换到该页。__ 

```objectivec
//切换页面
WhiteGlobalState *state = [[WhiteGlobalState alloc] init];
state.currentSceneIndex = [magixPhase.pptImages count] - 1;
[self.room setGlobalState:state];

//在index 1处，插入一个新的空白页
[self.room insertNewPage:1];
//移除index 1的页面
[self.room removePage:1]
```

# 主播模式
参考 WhiteBroadcastState。
White SDK 提供的白板是向四方无限延伸的。同时也允许用户通过鼠标滚轮、手势等方式移动白板。因此，即便是同一块白板的同一页，不同用户的屏幕上可能看到的内容是不一样的。

为此，我们引入「主播模式」这个概念。主播模式将房间内的某一个人设为主播，他/她屏幕上看到的内容即是其他所有人看到的内容。当主播进行视角的放缩、移动时，其他人的屏幕也会自动进行放缩、移动。

主播模式中，主播就好像摄像机，其他人就好像电视机。主播看到的东西会被同步到其他人的电视机上。

## 修改主播模式

可以通过生成 `WhiteBroadcast` 类，设置 `viewMode` 枚举属性，传递给 WhiteRoom，来修改主播模式。
具体代码参考
```objectivec
typedef NS_ENUM(NSInteger, WhiteViewMode) {
    // 自由模式
    // 你可以自由放缩、移动视角。
    // 即便房间里有主播，主播也无法影响你的视角。
    WhiteViewModeFreedom,
    // 追随模式
    // 你将追随主播的视角。主播在看哪里，你就会跟着看哪里。
    // 在这种模式中如果你放缩、移动视角，将自动切回 freedom模式。
    WhiteViewModeFollower,
    // 主播模式
    // 房间内其他人的视角模式会被自动修改成 follower，并且强制观看你的视角。
    // 如果房间内存在另一个主播，该主播的视角模式也会被强制改成 follower。
    // 就好像你抢了他/她的主播位置一样。
    WhiteViewModeBroadcaster,
};

//修改视角模式
WhiteBroadcastState *state = [[WhiteBroadcastState alloc] init];
[self.room setViewMode:state];
```

## 获取当前视角状态
```objectivec
[self.room getBroadcastStateWithResult:^(WhiteBroadcastState *state) {
    NSLog(@"%@", [state jsonString]);
}];
```

# 视角中心
同一个房间的不同用户各自的屏幕尺寸可能不一致，这将导致他们的白板都有各自不同的尺寸。实际上，房间的其他用户会将白板的中心对准主播的白板中心（注意主播和其他用户的屏幕尺寸不一定相同）。

我们需要通过如下方法设置白板的尺寸，以便主播能同步它的视角中心。

```objectivec
[room setViewSizeWithWidth:100 height:100];
```

尺寸应该和白板在产品中的实际尺寸相同（一般而言就是浏览器页面或者应用屏幕的尺寸）。如果用户调整了窗口大小导致白板尺寸改变。应该重新调用该方法刷新尺寸。


