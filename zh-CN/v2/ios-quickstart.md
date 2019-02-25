# iOS 快速开始

Hi, 亲爱的开发者，欢迎使用 White 白板。本教程将引导你在自己的 iOS 工程中引入一块互动白板。不过首先，我们假定你已经了解 Objective-C 的基础语法。


# 开始准备

* 下载 [Xcode](https://itunes.apple.com/cn/app/xcode/id497799835?ls=1&mt=12) 并配置 iOS 开发环境。

# 添加依赖

* 首先，你需要参考 [iOS SDK安装](/zh-CN/v2/ios-sdk-install.md) ，在 Podfile 中，添加 White-iOS-SDK 的依赖。使用 `pod install` 安装White-iOS-SDK。

# 引入 white-sdk 相关头文件

* 在需要添加白板的 ViewController 实例中，引入 White-iOS-SDK 的头文件文件 WhiteSDK.h。

```objectivec
#import <White-SDK-iOS/WhiteSDK.h>

@interface ViewController ()
//需要持有WhiteRoom实例，对whiteboard进行各种操作
@property (nonatomic, strong) WhiteRoom *room;
@property (nonatomic, strong) WhiteSDK *sdk;
@property (nonatomic, strong) WhiteBoardView *boardView;
@end
```

# 使用 SDK 创建白板

## 1. 获取权限

首先，我们需要获取房间的 RoomUUID  RoomToken 。

有以下两种情况：

- 1. 创建一个全新的房间: 通过openAPI，创建一个新房间，获取 `RoomUUID` `RoomToken` ，然后再加入房间。
- 2. 进入一个已有的房间：有 `RoomUUID` ，通过openAPI，获取到对应的 `RoomToken` 。

demo中，我们暂时只考虑创建房间。

为了确保安全性，我们推荐您参考 [最佳实践](/zh-CN/v2/concept.md) ，通过后端进行获取 `RoomToken` 。
在Demo中，我们在使用 iOS 官方 API 请求 OpenAPI 获取`RoomUUID` 和 `RoomToken` 。

```objectivec
- (void)creatNewRoomRequestWithResult:(void (^) (BOOL success, id response))result;
{
    // self.token 为字符串，具体的获取，请参考 https://developer.herewhite.com/#/concept
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://cloudcapiv3.herewhite.com/room?token=%@", self.sdkToken]]];
    NSMutableURLRequest *modifyRequest = [request mutableCopy];
    [modifyRequest setHTTPMethod:@"POST"];
    [modifyRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [modifyRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    // post请求中，可设置房间名，人数限制
    NSDictionary *params = @{@"name": @"test", @"limit": @110};
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
```

## 2. 创建实例

创建 `WhiteBoardView` 和 `WhiteSDK`， 在 `ViewDidLoad` 中创建sdk需要的实例类。

```objectivec
- (void)viewDidLoad {
    [super viewDidLoad];
    WhiteBoardView *boardView = [[WhiteBoardView alloc] init];
    // WhiteSdkConfiguration 是白板的配置项，主要是用来规定最大缩放比例，您可以直接使用defaultConfig（最大1000%，最小10%）
    WhiteSDK *sdk = [[WhiteSDK alloc] initWithWhiteBoardView:self.boardView config:[WhiteSdkConfiguration defaultConfig]];
    // 这里我们推荐创建属性，持有WhiteBoardView 和 WhiteSDK。
    self.boardView = boardView;
    self.sdk = sdk;
}
```

## 3. 加入白板

在 ViewDidLoad 中，调用 `creatNewRoomRequestWithResult:` 方法，获取 `RoomUUID` 以及`RoomToken` API。在回调中通过调用 WhiteSDK joinRoomWithRoomUuid 加入和连接白板。

```objectivec
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

# Demo 代码获取

- [white-iOS-Demo](https://github.com/duty-os/white-demo-ios) 

