# 教具

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

## 教具列表

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

# 插入图片

相关 API：

```Java
public void insertImage(ImageInformation imageInfo);
public void completeImageUpload(String uuid, String url);
```

1. 首先创建 `ImageInformation` 类，配置图片，宽高，以及中心点位置，设置 uuid，确保 uuid 唯一即可。
1. 调用 `insertImage:` 方法，传入 `ImageInformation` 实例。白板此时就先生成一个占位框。
1. 图片通过其他方式上传或者通过其他方式直接获取到图片的网络，在获取图片地址后，调用
`completeImageUpload` 方法，uuid 参数为 `insertImage:` 方法传入的 uuid，src 为实际图片网络地址。

## 插入PPT 与插入图片 的区别

区别| 插入PPT | 插入图片
---------|----------|---------
 调用后结果 | 会自动新建多个白板页面，但是仍然保留在当前页（所以无明显区别），需要通过翻页API进行切换 | 产生一个占位界面，插入真是图片，需要调用 `completeImageUploadWithUuid:src` ,传入占位界面的 uuid，以及图片的网络地址 |
 移动 | 无法移动，所以不需要位置信息 | 可以移动，所以插入时，需要提供图片大小以及位置信息
 与白板页面关系 | 插入 ppt 的同时，白板就新建了一个页面，这个页面的背景就是 PPT 图片 | 是当前白板页面的一部分，同一个页面可以加入多张图片

# 图片网址替换

部分情况下，我们需要对某个图片进行签名，以保证图片只在内部使用。

替换API可以在图片实际插入白板前进行拦截，修改最后实际插入的图片地址。**该方法对 ppt 图片和普通插入图片都有效。**
在回放时，图片地址仍然为未替换的地址，也需要通过此 API 进行签名。

//TODO: 检查
```Java
WhiteSdkConfiguration sdkConfig = new WhiteSdkConfiguration(DeviceType.touch, 10, 0.1);
//必须在sdk 初始化时，就设置替换
sdkConfig.setHasUrlInterrupterAPI(true);

//初始一个实现了 UrlInterrupter interface 的类，作为 WhiteSDK 初始化参数即可。
UrlInterrupterObject interrupter = new UrlInterrupterObject()
WhiteSdk whiteSdk = new WhiteSdk(whiteBroadView PlayActivity.this, interrupter);
```

* 注意点：

1. 该 API 会在渲染时，被频繁调用。如果没有需求，就不需要使用该方法。
1. 该方法会同时对 ppt插入以及图片插入API起效。

# 主播模式

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

# 只读

你可以通过 `room.disableOperations(true)` 来禁止用户操作白板。

你可以通过 `room.disableOperations(false)` 来恢复用户操作白板的能力。

# 缩放

一方面通过手势可以放缩白板（iOS 和 Android 上使用双指手势、mac os 使用双指手势、windows 使用鼠标中键的滚轮），另一方面也可以通过 `zoomChange` 来缩放白板。

```java
room.zoomChange(10);
```

# 用户头像显示

* 2.0.0-beta7 版本新增功能

## 1. 初始化

在初始化 SDK 时，设置 WhiteSdkConfiguration 中的 userCursor 参数。

```Java
WhiteSdkConfiguration sdkConfiguration = new WhiteSdkConfiguration(DeviceType.touch, 10, 0.1, true);
sdkConfiguration.setUserCursor(true);
```

## 2. 加入房间

`RoomParams` 增加了 `memberInfo` 属性，可以初始化传入或初始化后设置。
像之前一样调用加入房间方法即可。

```Java
// 初始化 MemberInformation 实例，传入 userId 属性。
MemberInformation info = new MemberInformation("313131");
// 设置想显示的头像
info.setAvatar("https://white-pan.oss-cn-shanghai.aliyuncs.com/40/image/mask.jpg");

RoomParams roomParams = new RoomParams("uuid", "roomToken", info);
```

MemberInformation 的 userId 属性，会被用来检测用户登录状态， **当加入的用户 userId 一致时，后加入的用户，会将前面加入的用户踢出房间**。

# 主动延时

*1.x 不提供该 API， `2.0.0-beta8` 新增API。*

```Java
//Room.java
//设置延迟秒数
public void setTimeDelay(Integer timeDelay)
//获取本地客户端，自动延时的秒数
public Integer getTimeDelay()
```

快速设置白板延时，人为给白板增加一部分延时，延迟播放，满足 HLS 情况下与音视频同步的需求。

注意点：

1. 参数单位为秒。
1. 该方法只对本地客户端有效。
1. 该方法会同时影响自定义时间，用户头像回调事件。
1. 用户本地绘制，仍然会实时出现。


# 清屏 API

* 2.0.0-beta10 及其后续版本提供

```Java
/**
 清除当前屏幕内容

 @param retainPPT 是否保留 ppt
 */
public void cleanScene(boolean retainPpt)
```