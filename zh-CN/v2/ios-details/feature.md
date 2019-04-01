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

@interface WhiteRoom : NSObject

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

/** 封装上述两个 API */
- (void)insertImage:(WhiteImageInformation *)imageInfo src:(NSString *)src;

@end
```

<details><summary>插入图片 API——需要异步获取图片地址</summary>

1. 首先创建 `WhiteImageInformation` 类，配置图片，宽高，以及中心点位置，设置 uuid，确保 uuid 唯一即可。
1. 调用 `insertImage:` 方法，传入 `WhiteImageInformation` 实例。白板此时就先生成一个占位框。
1. 图片通过其他方式上传或者直接获取图片地址后，调用
`completeImageUploadWithUuid: src:` 方法，uuid 参数为 `insertImage:` 方法传入的 uuid，src 为图片网络地址。

</details>

<br>
v2版本中，我们将插入图片 API 封装成了一个 API。如果开发者在插入图片时，已经知道图片信息，可以直接使用封装好的 API

```Objective-C
WhiteImageInformation *info = [[WhiteImageInformation alloc] init];
info.width = 200;
info.height = 300;
info.uuid = @"WhiteImageInformation";
[self.room insertImage:info src:@"https://white-pan.oss-cn-shanghai.aliyuncs.com/101/image/alin-rusu-1239275-unsplash_opt.jpg"];
```

## 插入PPT 与插入图片 的区别

区别| 插入PPT | 插入图片
---------|----------|---------
 调用后结果 | 会自动新建多个白板页面，但是仍然保留在当前页（所以无明显区别），需要通过翻页API进行切换 | 产生一个占位界面，插入真是图片，需要调用 `completeImageUploadWithUuid:src` ,传入占位界面的 uuid，以及图片的网络地址 |
 移动 | 无法移动，所以不需要位置信息 | 可以移动，所以插入时，需要提供图片大小以及位置信息
 与白板页面关系 | 插入 ppt 的同时，白板就新建了一个页面，这个页面的背景就是 PPT 图片 | 是当前白板页面的一部分，同一个页面可以加入多张图片

# 图片网址替换

部分情况下，我们需要对某个图片进行签名，以保证图片只在内部使用。

替换API可以在图片实际插入白板前进行拦截，修改最后实际插入的图片地址。**该方法对 ppt 图片和普通插入图片都有效。**
在回放时，图片地址仍然为未替换的地址，也需要通过此 API 进行签名。

该方法为 `WhiteCommonCallbackDelegate` 协议中的一个申明方法，属于被动调用。

**如需启用，请在初始化 SDK 时，将 `WhiteSdkConfiguration` 的 `enableInterrupterAPI` 属性，设置为 YES。** 并在 `WhiteSDK` 初始化时，使用一下方法传入实现了该 protocol 的实例 

```Objective-C
- (instancetype)initWithWhiteBoardView:(WhiteBoardView *)boardView config:(WhiteSdkConfiguration *)config commonCallbackDelegate:(nullable id<WhiteCommonCallbackDelegate>)callback
```

或者在想要使用时，调用 `whiteSDK` 的 `setCommonCallbackDelegate:` 方法，设置。

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
//该数值为白板与原始大小的缩放比例
[room zoomChange:10];
```

# 移动

白板支持双指手势，双指进行平移，即可移动白板（模拟器中可以通过 shift + option + 鼠标，来模式该手势）。

# 用户头像显示

* 2.0.2 版本，新增功能

## 1. 初始化

在初始化 SDK 时，设置 WhiteSdkConfiguration 中的 userCursor 参数。

```Objective-C

@interface WhiteSdkConfiguartion ： WhiteObject

/** 显示操作用户头像(需要在加入房间时，配置用户信息) */
@property (nonatomic, assign) BOOL userCursor;

@end
```

## 2. 加入房间

通过以下 API ，传入用户信息

```Objective-C
@interface WhiteSDK : NSObject
//加入房间
- (void)joinRoomWithConfig:(WhiteRoomConfig *)config callbacks:(nullable id<WhiteRoomCallbackDelegate>)callbacks completionHandler:(void (^) (BOOL success, WhiteRoom * _Nullable room, NSError * _Nullable error))completionHandler;
@end
```

```Objective-C
@interface WhiteRoomConfig : WhiteObject
//初始化房间参数
- (instancetype)initWithUuid:(NSString *)uuid roomToken:(NSString *)roomToken memberInfo:(WhiteMemberInformation * _Nullable)memberInfo;
@end
```

在初始化房间参数时，传入 `WhiteMemberInformation` 实例即可。如果配置用户头像信息地址（推荐使用 https 地址，否则需要开启 iOS ATS 功能，允许 http 链接），如果不配置，则会显示 SDK 的默认占位符。
注意： **当加入的用户 userId 一致时，后加入的用户，会将前面加入的用户踢出房间**。