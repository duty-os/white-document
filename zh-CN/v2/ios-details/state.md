# 订阅白板状态

通过订阅白板状态，你可以得知当前白板的以下状态变化：

1. 白板网络连接状态变化
1. 白板 RoomState 属性中发生的值变化。（教具，视角，等都在该类中，后续增加的功能状态，一般也都集中在这里）
1. 白板失去连接（附带错误信息）
1. 当前用户被远程服务器踢出房间，以及原因。
1. 操作错误信息，由于存在于服务器通信的关系，部分 API 操作，可能无法理解返回错误信息，一般都会将错误放入此处。
1. 图片加载事件。（该 API 比较特殊，其他 API 都只是单纯的接收，该 API可修改白板将要加载的图片地址）

## 回调API列表：

```Objective-C

//WhiteRoomCallbacks.h 文件

@protocol WhiteRoomCallbackDelegate <NSObject>

@optional

/** 白板网络连接状态回调事件 */
- (void)firePhaseChanged:(WhiteRoomPhase)phase;

/**
 白板中RoomState属性，发生变化时，会触发该回调。
 注意：主动设置的 RoomState，不会触发该回调。
 @param modifyState 发生变化的 RoomState 内容
 */
- (void)fireRoomStateChanged:(WhiteRoomState *)modifyState;

- (void)fireBeingAbleToCommitChange:(BOOL)isAbleToCommit;

/** 白板失去连接回调，附带错误信息 */
- (void)fireDisconnectWithError:(NSString *)error;

/** 用户被远程服务器踢出房间，附带踢出原因 */
- (void)fireKickedWithReason:(NSString *)reason;

/** 用户错误事件捕获，附带用户 id，以及错误原因 */
- (void)fireCatchErrorWhenAppendFrame:(NSUInteger)userId error:(NSString *)error;

/**
 白板自定义事件回调，可以参考自定义需求-自定义事件文档
 */
- (void)fireMagixEvent:(WhiteEvent *)event;

/*
 调用插入图片API时，可以通过此方法，对使用插入图片API(completeImageUploadWithUuid:src:) 中，传入的 src 进行修改。
 该方法会被频繁调用，执行应尽可能快返回；如果没有对应需求，最好不要实现该方法。
 如果需要该 API，最好使用最新的 SDK 初始化方法初始化 WhiteSDK。
 */
- (NSString *)urlInterrupter:(NSString *)url;

@end
```

## 何时传入delegate？

在调用以下API生成SDK时，传入 `callbacks` 参数。在事件发生时，SDK 会调用以上 API。

```Objective-C

@interface WhiteSDK : NSObject
- (instancetype)initWithBoardView:(WhiteBoardView *)boardView config:(WhiteSdkConfiguration *)config callbackDelegate:(id<WhiteRoomCallbackDelegate>)callbackDelegate;
```

# 教具

SDK 提供多种工具，如选择器、铅笔、文字、圆形工具、矩形工具。同时还提供图片展示工具和 PPT 工具。这些功能的展现形式，关系到具体网页应用本身的交互设计、视觉风格。考虑到这一点，白板上没有直接提供这些 UI 组件。你需要通过程序调用的方式，来让白板使用这些功能。

```Objective-C

//WhiteMemberState.h 文件

typedef NSString * WhiteApplianceNameKey;

extern WhiteApplianceNameKey const AppliancePencil;
extern WhiteApplianceNameKey const ApplianceSelector;
extern WhiteApplianceNameKey const ApplianceText;
extern WhiteApplianceNameKey const ApplianceEllipse;
extern WhiteApplianceNameKey const ApplianceRectangle;
extern WhiteApplianceNameKey const ApplianceEraser;

@interface WhiteMemberState : WhiteObject
/** 教具，初始教具为pencil，无默认值 */
@property (nonatomic, copy) WhiteApplianceNameKey currentApplianceName;
/** 传入格式为[@(0-255),@(0-255),@(0-255)]的RGB */
@property (nonatomic, copy) NSArray<NSNumber *> *strokeColor;
/** 画笔粗细 */
@property (nonatomic, strong) NSNumber *strokeWidth;
@property (nonatomic, strong) NSNumber *textSize;
@end

```

## 教具列表

| 名称 | Objective-C 常量 | 描述 |
| :--- | :--- | :--- |
| 选择 | ApplianceSelector | 选择、移动、放缩 |
| 铅笔 | AppliancePencil | 画出带颜色的轨迹 |
| 矩形 | ApplianceRectangle | 画出矩形 |
| 椭圆 | ApplianceEllipse | 画出正圆或椭圆 |
| 橡皮 | ApplianceEraser | 删除轨迹 |
| 文字 | ApplianceEraser | 编辑、输入文字 |

## 切换教具

White SDK 提供多种教具，我们可以通过生成 `WhiteMemberState` 实例，来设置当前的教具。

* 例子：我们将当前教具设置为「铅笔」工具：

```Objective-C
WhiteMemberState *memberState = [[WhiteMemberState alloc] init];
//白板初始状态时，教具默认为画笔pencil。
memberState.currentApplianceName = AppliancePencil;
[whiteRoom setMemberState:memberState];
```

## 设置教具颜色，粗细

`WhiteMemberState` 还有其他属性:

```Objective-C
@interface WhiteMemberState : WhiteObject
/** 传入格式为[@(0-255),@(0-255),@(0-255)]的RGB */
@property (nonatomic, copy) NSArray<NSNumber *> *strokeColor;
/** 画笔粗细 */
@property (nonatomic, strong) NSNumber *strokeWidth;
```

1. `strokeColor` 属性，可以调整教具的颜色。该属性，能够影响铅笔、矩形、椭圆、文字工具颜色。
2. `strokeWidth` 属性，可以调整教具粗细。该属性，能够影响铅笔、矩形、椭圆、文字工具颜色。

## 获取当前教具
```Objective-C
[whiteRoom getMemberStateWithResult:^(WhiteMemberState *state) {
    NSLog(@"%@", [state jsonString]);
}];
```

# 插入图片

```Objective-C
/**
 1. 先使用 insertImage API，插入占位图
 */
- (void)insertImage:(WhiteImageInformation *)imageInfo;

/**
 2. 再通过 completeImageUploadWithUuid:src: 替换内容
 替换占位图中的内容

 @param uuid insertImage API 中，imageInfo 传入的图片 uuid
 @param src 图片的网络地址
 */
- (void)completeImageUploadWithUuid:(NSString *)uuid src:(NSString *)src;
```

1. 首先创建 `WhiteImageInformation` 类，配置图片，宽高，以及中心点位置，设置 uuid，确保 uuid 唯一即可。
1. 调用 `insertImage:` 方法，传入 `WhiteImageInformation` 实例。白板此时就先生成一个占位框。
1. 图片通过其他方式上传或者直接获取图片地址后，调用
`completeImageUploadWithUuid: src:` 方法，uuid 参数为 `insertImage:` 方法传入的 uuid，src 为图片网络地址。

## 插入PPT 与插入图片 的区别

区别| 插入PPT | 插入图片
---------|----------|---------
 调用后结果 | 会自动新建多个白板页面，但是仍然保留在当前页（所以无明显区别），需要通过翻页API进行切换 | 产生一个占位界面，插入真是图片，需要调用 `completeImageUploadWithUuid:src` ,传入占位界面的 uuid，以及图片的网络地址 |
 移动 | 无法移动，所以不需要位置信息 | 可以移动，所以插入时，需要提供图片大小以及位置信息
 与白板页面关系 | 插入 ppt 的同时，白板就新建了一个页面，这个页面的背景就是 PPT 图片 | 是当前白板页面的一部分，同一个页面可以加入多张图片

# 图片网址替换

部分情况下，我们需要对某个图片进行签名，以保证图片只在内部使用。 此 API `- (NSString *)urlInterrupter:(NSString *)url;` 可以在图片实际插入白板前进行拦截，修改最后实际插入的图片地址。该方法对 ppt 图片和普通插入图片都有效。

该方法为 `WhiteRoomCallbackDelegate` 协议中的一个申明方法，属于被动调用。如果没有需求，最好就不要实现。

# 切换视角模式 —— 主播，观众，自由

White SDK 提供的白板是向四方无限延伸的。同时也允许用户通过鼠标滚轮、手势等方式移动白板。因此，即便是同一块白板的同一页，不同用户的屏幕上可能看到的内容是不一样的。

为此，我们引入「主播模式」这个概念。主播模式将房间内的某一个人设为主播，他/她屏幕上看到的内容即是其他所有人看到的内容。当主播进行视角的放缩、移动时，其他人的屏幕也会自动进行放缩、移动。

主播模式中，主播就好像摄像机，其他人就好像电视机。主播看到的东西会被同步到其他人的电视机上。

## 视角枚举

```Objective-C
typedef NS_ENUM(NSInteger, WhiteViewMode) {
    // 自由模式
    // 用户可以自由放缩、移动视角。
    // 即便房间里有主播，主播也无法影响用户的视角。
    WhiteViewModeFreedom,
    // 追随模式
    // 用户将追随主播的视角。主播在看哪里，用户就会跟着看哪里。
    // 在这种模式中，如果用户进行缩放、移动视角操作，将自动切回 freedom模式。
    WhiteViewModeFollower,
    // 主播模式
    // 房间内其他人的视角模式会被自动修改成 follower，并且强制观看该用户的视角。
    // 如果房间内存在另一个主播，该主播的视角模式也会被强制改成 follower。
    WhiteViewModeBroadcaster,
};

//以下类，只有在 fireRoomStateChanged: 回调事件中，才会使用。
@interface WhiteBroadcastState : WhiteObject
@property (nonatomic, assign) WhiteViewMode viewMode;
@property (nonatomic, assign) NSInteger broadcasterId;
@property (nonatomic, strong) WhiteMemberInformation *broadcasterInformation;
@end

```

## 设置视角模式

* 例子：设置当前用户为主播视角

```
//只需要传入枚举值即可
[whiteRoom setViewMode:WhiteViewModeBroadcaster];
```

## 获取当前视角状态

```Objective-C
[self.room getBroadcastStateWithResult:^(WhiteBroadcastState *state) {
    NSLog(@"%@", [state jsonString]);
}];
```

# 视角中心

同一个房间的不同用户各自的屏幕尺寸可能不一致，这将导致他们的白板都有各自不同的尺寸。实际上，房间的其他用户会将白板的中心对准主播的白板中心（注意主播和其他用户的屏幕尺寸不一定相同）。

我们需要通过如下方法设置白板的尺寸，以便主播能同步它的视角中心。

```Objective-C
[room setViewSizeWithWidth:100 height:100];
```

尺寸应该和白板在产品中的实际尺寸相同（一般而言就是浏览器页面或者应用屏幕的尺寸）。如果用户调整了窗口大小导致白板尺寸改变。应该重新调用该方法刷新尺寸。

# 只读

```Objective-C
/** 进入只读模式，不响应用户任何手势 */
- (void)disableOperations:(BOOL)readonly;
```

# 缩放

用户可以通过手势（iOS上使用双指swipe手势、模拟器中按住 option + 鼠标进行模拟）对白板进行缩放操作。
另一方面，开发者也可以通过 `zoomChange` 来进行缩放。

```Objective-C
[room zoomChange:10];
```

# 移动

白板支持双指手势，双指进行平移，即可移动白板（模拟器中可以通过 shift + option + 鼠标，来模式该手势）。