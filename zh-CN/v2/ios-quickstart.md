# 添加依赖

* 根据 [iOS SDK安装](/zh-CN/v2/ios-sdk-install.md) ，在 Podfile 中，添加 White-iOS-SDK 的依赖。使用 `cocoapods` 安装White-iOS-SDK。

---

# 实例代码下载

**本文档中，所有内容都可以 [Pod 示例项目](https://github.com/duty-os/white-sdk-ios-release/tree/v2.x) 的 Example 项目中查看。**
由于 代码不断更新，本文档可能代码会与当前项目存在部分差异。

---

# 引入 SDK

* 在需要添加白板的 ViewController 实例中，引入 White-iOS-SDK 的头文件文件 WhiteSDK.h。

```Objective-C
#import <White-SDK-iOS/WhiteSDK.h>

@interface ViewController ()
//持有WhiteRoom实例，后续对 Whiteboard 进行各种操作时，都需要该实例
@property (nonatomic, strong) WhiteRoom *room;
@property (nonatomic, strong) WhiteSDK *sdk;
@property (nonatomic, strong) WhiteBoardView *boardView;
@end
```

## 1. 获取房间信息 <server 端 API>

首先，我们需要获取房间的 RoomUUID，RoomToken。
**创建房间，以及获取 RoomToken API 需要 Token，建议在服务端进行请求保存。具体 API，可以查看 server 端 API 文档。**

有以下两种情况

### 创建一个全新的房间

通过 `token` 向 server 端 API，创建一个新房间，获取 `RoomUUID` `RoomToken` ；然后加入房间

### 进入一个已存在的房间

通过 `token` ，`RoomUUID` ，向 server 端 API 请求获取 `RoomToken`；然后加入房间。

---

在本文档中，我们只提供了创建房间代码。Pod 中的 example 的 `WhiteUtils` 类，实现了创建以及加入已有房间的功能。
为了确保安全性，我们推荐您参考 [最佳实践](/zh-CN/v2/concept.md) ，通过后端进行获取 `RoomToken` 。

```Objective-C

#import "WhiteUtils.h"

@implementation WhiteUtils

- (void)creatNewRoomRequestWithResult:(void (^) (BOOL success, id response))result;
{
    // self.token 为字符串，具体的获取，请参考 https://developer.herewhite.com/#/concept
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://cloudcapiv4.herewhite.com/room?token=%@", self.sdkToken]]];
    NSMutableURLRequest *modifyRequest = [request mutableCopy];
    [modifyRequest setHTTPMethod:@"POST"];
    [modifyRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [modifyRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //@"mode": @"historied" 为可回放房间，默认为持久化房间。
    NSDictionary *params = @{@"name": @"test", @"limit": @110, @"mode": @"historied"};
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    [modifyRequest setHTTPBody:postData];
    
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:modifyRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error && result) {
                result(NO, nil);
            } else if (result) {
                NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                result(YES, responseObject);
            }
        });
    }];
    [task resume];
}

@end

```

## 2. 创建SDK实例

创建 `WhiteBoardView` 和 `WhiteSDK`， 在 `ViewDidLoad` 中创建sdk需要的实例类。

```objectivec
#import "WhiteRoomViewController.h"

@implementation

- (void)viewDidLoad {
    [super viewDidLoad];
    WhiteSdkConfiguration *config = [WhiteSdkConfiguration defaultConfig];
    
    //如果不需要拦截图片API，则不需要开启，页面内容较为复杂时，可能会有性能问题
    config.enableInterrupterAPI = YES;
    config.debug = YES;
    
    self.sdk = [[WhiteSDK alloc] initWithWhiteBoardView:self.boardView config:config commonCallbackDelegate:self.commonDelegate];
}

@end
```

## 3. 加入白板

在 ViewDidLoad 中，调用 `creatNewRoomRequestWithResult:` 方法，获取 `RoomUUID` 以及`RoomToken` API。在回调中通过调用 WhiteSDK joinRoomWithRoomUuid 加入和连接白板。

```Objective-C

- (void)viewDidLoad {
    [super viewDidLoad];

    WhiteBoardView *boardView = [[WhiteBoardView alloc] init];
    self.boardView = boardView;
    //注意：iOS 12 真机情况下，WhiteBoardView 需要先添加到视图栈中，WhiteSDK才能正常运行。
    self.boardView.frame = self.view.bounds;
    self.boardView.autoresizingMask = UIViewAutoresizingFlexibleWidth |  UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.boardView];

    WhiteSDK *sdk = [[WhiteSDK alloc] initWithWhiteBoardView:self.boardView config:[WhiteSdkConfiguration defaultConfig]];
    self.sdk = sdk;
    //当前步骤，新增代码
    [self creatNewRoomRequestWithResult:^(BOOL success, id response) {
        if (success) {
            //RoomToken，以及UUID获取，根据您后台服务器返回结构不同，获取方式会有所不同
            NSString *roomToken = response[@"msg"][@"roomToken"];
            NSString *uuid = response[@"msg"][@"room"][@"uuid"];
            [self.sdk joinRoomWithRoomUuid:uuid roomToken:roomToken callbacks:(id<WhiteRoomCallbackDelegate>)self completionHandler:^(BOOL success, WhiteRoom *room, NSError *error) {
                if (success) {
                    self.title = NSLocalizedString(@"我的白板", nil);
                    //这里，我们使用属性持有WhiteRoom
                    self.room = room;
                } else {
                    self.title = NSLocalizedString(@"加入失败", nil);
                    //TODO: error
                }
            }];
        } else {
            // 获取RoomToken，以及RoomUUID失败
        }
    }];
}

```

# 体验白板
 
好了，到这里，等待顶部导航栏变为 "我的白板" 。这时候，我们就成功添加了一个白板应用。在模拟器中，在模拟中，按住鼠标，随意涂抹，就能看到笔画啦。

![image.png | left | 488x850](./_images/iOS_screen.png)

# 代码获取

**本文档中，所有内容都可以 [Pod 示例项目](https://github.com/duty-os/white-sdk-ios-release/tree/v2.x) 的 Example 项目中查看。**

