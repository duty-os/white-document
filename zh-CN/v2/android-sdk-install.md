# 通过 Android Studio 进行开发

# 创建项目

使用 Android Studio 创建一个新的项目的时候，它的目录结构如下：
```plain
.
├── app                 // 应用源代码
    ├── ...
    ├── build.gradle    // 应用 Gradle 构建脚本
    ├── ...
├── build.gradle        // 项目 Gradle 构建脚本
├── YOUR-APP-NAME.iml   // YOUR-APP-NAME 为你的应用名称
├── gradle
└── settings.gradle首先打开根目录下的 build.gradle 进行如下标准配置：
```

# 配置 build.gradle

首先打开根目录下的 build.gradle 进行如下标准配置：

```plain
allprojects {
    repositories {
        jcenter()
        maven { url 'https://jitpack.io' }
    }
}
```

然后打开 app 目录下的 build.gradle 进行如下配置：

```plain
dependencies {
    compile 'com.github.duty-os:white-sdk-android:2.0.0-beta10'
    # 使用动态 ppt 功能的用户，请暂时使用 2.0.0-ppt 功能
}
```

* 这时你会看到 Android Studio 在编辑器的顶部有一行提示 

`gradle files have changed since last project sync. a project sync may be necessary for the IDE to work properly` 

* 点击 `Sync Now` 按钮后提示变为 `Gradle project sync in process...` ，稍等一段时间（依你的网络环境而定）后提示消失，恭喜你 White Android SDK 集成完毕！

# Proguard 配置

```
# SDK model
-keep class com.herewhite.** { *; }
-keepattributes  *JavascriptInterface*
-keepattributes Signature 
# Gson specific classes 
-keep class sun.misc.Unsafe { *; } 
-keep class com.google.gson.stream.** { *; } 
# Application classes that will be serialized/deserialized over Gson 
-keep class com.google.gson.examples.android.model.** { *; }
-keep class com.google.gson.** { *;}
```

