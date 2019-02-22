# Android 快速开始

Hi, 亲爱的开发者，欢迎使用 White 白板。本教程将引导你在自己的 Android 工程中引入一块互动白板。不过首先，我们假定你已经了解 Java 的基础语法。

# 开始的准备

* 下载 [Android Studio](https://developer.android.com/studio/?hl=zh-cn#downloads) 并配置 Android 开发环境，请参考[开发环境配置](https://www.jianshu.com/p/aaff8bb91f69) 。

# 添加依赖和界面代码

你可以自己创建一个 Android 工程，也推荐你下载我们的空项目模板 [Tutorial-stepOne.zip](https://document.herewhite.com/tutorial/demo/android/tutorial-stepOne.zip) 到本地进行快速开始的学习。

不管是下载我们提供的项目模板或者创建的工程看到目录结构如下：

```plain
.
├── app            
│   └── src
│       ├── main
│       │   ├── AndroidManifest.xml
│       │   ├── java
│       │   │   └── com
│       │   │       └── herewhite
│       │   │           └── tutorial
│       │   │               └── MainActivity.java
│       │   └── res
│       │       ├── layout
│       │       │   └── activity_main.xml
├── build.gradle        
├── tutorial.iml  
├── gradle
└── settings.gradle
```
# 安装 SDK

* 首先你需要参考 [Android SDK 安装](Android_SDK_install.md)文档，进行 White SDK 安装。

# 添加 UI 代码

* 我们使用 Android XML 来描述 UI 视图，修改 activity\_main.xml 为如下内容，可以看到整个视图由一个白板页面填充，这个页面实现（com.herewhite.sdk.WhiteBroadView）由 White Android SDK 提供。

```xml
<?xml version="1.0" encoding="utf-8"?>
<LinearLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:id="@+id/activity_main"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:orientation="vertical"
    tools:context=".MainActivity">

    <com.herewhite.sdk.WhiteBroadView
        android:id="@+id/white"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:visibility="visible" />

</LinearLayout>
```

* 添加 DemoAPI.java 到 com.herewhite.tutorial 包中，内容如下：

```java
package com.herewhite.tutorial;
import com.google.gson.Gson;

import java.util.HashMap;
import java.util.Map;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.MediaType;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.RequestBody;
public class DemoAPI {

    public static final MediaType JSON
            = MediaType.parse("application/json; charset=utf-8");
    // 获取 Token 请参考 https://developer.herewhite.com/#/concept
    public static final String TOKEN = "WHITEcGFydG5lcl9pZD1DYzlFNTJhTVFhUU5TYmlHNWJjbkpmVThTNGlNVXlJVUNwdFAmc2lnPTE3Y2ZiYzg0ZGM5N2FkNDAxZmY1MTM0ODMxYTdhZTE2ZGQ3MTdmZjI6YWRtaW5JZD00JnJvbGU9bWluaSZleHBpcmVfdGltZT0xNTY2MDQwNjk4JmFrPUNjOUU1MmFNUWFRTlNiaUc1YmNuSmZVOFM0aU1VeUlVQ3B0UCZjcmVhdGVfdGltZT0xNTM0NDgzNzQ2Jm5vbmNlPTE1MzQ0ODM3NDYzMzYwMA";
    private OkHttpClient client = new OkHttpClient();
    private Gson gson = new Gson();

    public void createRoom(String name, int limit, Callback callback) {
        Map<String, Object> roomSpec = new HashMap<>();
        roomSpec.put("name", name);
        roomSpec.put("limit", limit);
        RequestBody body = RequestBody.create(JSON, gson.toJson(roomSpec));
        Request request = new Request.Builder()
                .url("https://cloudcapiv3.herewhite.com/room?token=" + TOKEN)
                .post(body)
                .build();
        Call call = client.newCall(request);
        call.enqueue(callback);
    }
}
```

* 我们在 Demo 项目中使用了常见的 okHttp 作为 Open API 的请求库，所以我们还需要修改 app 中的 build.gradle 添加依赖：

```
.
├── app                 
    ├── ...
    ├── build.gradle    // 修改此文件
    ├── ...
├── build.gradle        
├── YOUR-APP-NAME.iml   
├── gradle
└── settings.gradle
```

```
dependencies {
    compile 'com.github.duty-os:white-sdk-android:1.3.0'
    compile 'com.squareup.okhttp3:okhttp:3.11.0' // 添加这行
}
```

* 此时，项目结构如下，点击编辑器上面的 `Sync Now` 按钮，喝杯茶后回来。

```plain
.
├── app            
│   └── src
│       ├── main
│       │   ├── AndroidManifest.xml
│       │   ├── java
│       │   │   └── com
│       │   │       └── herewhite
│       │   │           └── tutorial
│       │   │               ├── DemoAPI.java
│       │   │               └── MainActivity.java
│       │   └── res
│       │       ├── layout
│       │       │   └── activity_main.xml
├── build.gradle        
├── tutorial.iml  
├── gradle
└── settings.gradle
```

# 添加主要逻辑

前面的准备工作完成后，我们修改 MainActivity.java 尝试渲染出白板并完成本教程。现在打开 MainActivity.java ，在 MainActivity.java 的初始化方法 `onCreate`  中通过 Open API 创建一个白板并获取他的 uuid 和 roomToken 后就可以通过 `WhiteSdk` 的 `joinRoom` 连接并加入白板（Demo 中使用 DemoAPI.java 中的 createRoom 来创建白板和获取 uuid 和 roomToken，这种方式是不安全的，正确做法参考：[最佳实践](./concept.md)）。

```java
final Gson gson = new Gson();
final WhiteBroadView whiteBroadView = (WhiteBroadView) findViewById(R.id.white);
new DemoAPI().createRoom("unknow", 100, new Callback() {
    @Override
    public void onFailure(Call call, IOException e) {

    }

    @Override
    public void onResponse(Call call, Response response) throws IOException {
        JsonObject room = gson.fromJson(response.body().string(), JsonObject.class);
        final String uuid = room.getAsJsonObject("msg").getAsJsonObject("room").get("uuid").getAsString();
        String roomToken = room.getAsJsonObject("msg").get("roomToken").getAsString();
        Log.i("white", uuid + "|" + roomToken);
        joinRoom(whiteBroadView, uuid, roomToken);
    }
});
```

* 这时因为没有添加 `joinRoom` 方法，所以编译不过。

* 现在我们来添加 `joinRoom`  用以创建 WhiteSdk 对象，传入的第一个参数是通过 `findViewById` 获取到的在 XML 中声明的 `com.herewhite.sdk.WhiteBroadView` ，通过 id `android:id="@+id/white"` 进行关联。内容如下：

```java
private void joinRoom(WhiteBroadView whiteBroadView, String uuid, String roomToken) {
        WhiteSdk whiteSdk = new WhiteSdk(
                whiteBroadView,
                this,
                new WhiteSdkConfiguration(DeviceType.touch, 10, 0.1));
        whiteSdk.addRoomCallbacks(new AbstractRoomCallbacks() {
            @Override
            public void onPhaseChanged(RoomPhase phase) {}
            @Override
            public void onRoomStateChanged(RoomState modifyState) {}
        });
        whiteSdk.joinRoom(new RoomParams(uuid, roomToken), new Promise<Room>() {
            @Override
            public void then(Room room) {}
            @Override
            public void catchEx(SDKError t){}
        });
    }
```

`joinRoom` 方法分为三步：

* 创建 WhiteSDK 对象。
* 为 WhiteSDK 添加监听器，这些监听器可以实时获取白板运行期间的状态和信息，SDK 会在状态改变后通知监听器。
* 使用 WhiteSDK `joinRoom` 加入并连接白板，该方法可以传入 Promise 对象，如果成功连接会回调 `then` 方法，并回传给你 Room 对象。Room 对象带有更改白板行为的 API，用来帮助你构建自己的业务场景。

# 体验 demo

在 Android Studio中， 右键点击 MainActivity.java ，在选出的菜单中选择 `Run MainActivity` 就可以在模拟器中运行 Demo 了。


![屏幕快照 2018-08-19 下午12.50.24.png | left | 166x296](https://cdn.nlark.com/yuque/0/2018/png/102615/1534654267108-1a16f744-076c-4f1e-a0fe-f378c693148a.png)


最终完成的工程在[ tutorial.zip](https://document.herewhite.com/tutorial/demo/android/tutorial.zip)

# Demo 代码获取

[Android demo](https://github.com/duty-os/white-demo-android)。

