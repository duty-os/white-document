# Develop Tool

We assume that you develop with Android Studio

# Create project

When using Android Studio to create a new project, its directory structure is as follows:

```plain
.
├── app                 // Application source code
    ├── ...
    ├── build.gradle    // Apply Gradle build script
    ├── ...
├── build.gradle        // Project Gradle build script
├── YOUR-APP-NAME.iml   // YOUR-APP-NAME is your app name
├── gradle
└── settings.gradle First open the build.gradle in the root directory to perform the following standard configuration:
```

# Configuring build.gradle

First open the build.gradle in the root directory to perform the following standard configuration:

```plain
allprojects {
    repositories {
        jcenter()
        maven { url 'https://jitpack.io' }
    }
}
```

Then open the build.gradle in the app directory and configure it as follows:

```plain
dependencies {
    compile 'com.github.duty-os:white-sdk-android:1.3.11'
}
```

* At this point you will see that Android Studio has a line at the top of the editor.

`gradle files have changed since last project sync. a project sync may be necessary for the IDE to work properly` 

* After clicking the `Sync Now` button, the prompt changes to `Gradle project sync in process...`. After a while (depending on your network environment), the prompt disappears. Congratulations on the integration of the White Android SDK!

