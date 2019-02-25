# Android quick start

Hi, Dear developer, welcome to the Whiteboard. This tutorial will guide you through the introduction of an interactive whiteboard in your Android project. But first, let's assume that you already know the underlying syntax of Objective-C.

# Preparation for the start

* Download [Android Studio](https://developer.android.com/studio/?hl=zh-cn#downloads) And configure the Android development environment, please refer to [development environment configuration](https://www.jianshu.com/p/aaff8bb91f69) 。

# Add dependencies and interface code

You can create an Android project yourself and recommend that you download our empty project template. [Tutorial-stepOne.zip](https://document.herewhite.com/tutorial/demo/android/tutorial-stepOne.zip) go to the local to start learning quickly.

Whether it is downloading the project template we provide or the project created, we see the directory structure as follows:

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
# Install SDK

* First you need to refer to [Android SDK Installation](/en-uk/v2/Android_SDK_install.md) documentation for White SDK installation

# Add UI code

* We use Android XML to describe the UI view, modify activity\_main.xml as follows, and see that the entire view is populated with a whiteboard page. This page implementation (com.herewhite.sdk.WhiteBroadView) is provided by the White Android SDK.

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

* Add DemoAPI.java to the com.herewhite.tutorial package as follows:

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
    // Get `Token` please refer to https://developer.herewhite.com/#/concept
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

* We used the common okHttp as the Open API request library in the Demo project, so we also need to modify the build.gradle in the app to add dependencies:

```
.
├── app                 
    ├── ...
    ├── build.gradle    // Modify this file
    ├── ...
├── build.gradle        
├── YOUR-APP-NAME.iml   
├── gradle
└── settings.gradle
```

```
dependencies {
    compile 'com.github.duty-os:white-sdk-android:1.3.0'
    compile 'com.squareup.okhttp3:okhttp:3.11.0' // Add this line
}
```

* At this point, the project structure is as follows, click the `Sync Now` button on the editor, come back after a cup of tea.

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

# Add primary logic

After the previous preparations are complete, we modify MainActivity.java to try to render the whiteboard and complete the tutorial. Now open MainActivity.java, create a whiteboard through the Open API in the initialization method `onCreate` of MainActivity.java and get its uuid and roomToken. Then you can connect and join the whiteboard through ``joinRoom` of `WhiteSdk` (use DemoAPI in Demo) CreateRoom in .java to create whiteboards and get uuid and roomToken is not safe, refer to: [Best Practices](/en-uk/v2/concept.md)）。

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

* At this time, because the `joinRoom` method is not added, it is compiled.

* Now let's add `joinRoom` to create the WhiteSdk object. The first argument passed in is `com.herewhite.sdk.WhiteBroadView` declared in XML via `findViewById` , via id `android:id= "@ id/white"` is associated. The content is as follows:

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

`joinRoom` the method is divided into three steps:

* Create a WhiteSDK object.
* Add listeners to the WhiteSDK that get real-time status and information during the whiteboard's run, and the SDK notifies the listener after the state changes.
* Use WhiteSDK `joinRoom` to join and connect to the whiteboard. This method can pass in the Promise object. If the connection is successful, the `then` method will be called back and passed back to your Room object. The Room object has an API for changing the behavior of the whiteboard to help you build your own business scenario. 

# Experience demo

In Android Studio, right click on MainActivity.java and select `Run MainActivity` from the selected menu to run Demo in the emulator.


![屏幕快照 2018-08-19 下午12.50.24.png | left | 166x296](https://cdn.nlark.com/yuque/0/2018/png/102615/1534654267108-1a16f744-076c-4f1e-a0fe-f378c693148a.png)


The final completed project is [tutorial.zip](https://document.herewhite.com/tutorial/demo/android/tutorial.zip)

# Demo code acquisition

[Android demo](https://github.com/duty-os/white-demo-android)。

