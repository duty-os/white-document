# 回放（持续更新中）

在教育领域中，上完课之后往往需要记录板书让学生可以复习使用；在会议场景下，会后也需要发出完整的会议记录来帮助后面执行讨论的成果。

为了更好的满足客户对回放的需求，我们在云端提供的白板回放的录制功能，客户再也不用花费高昂的人力物力去手动录制成视频来提供回放功能。

并且相比传统的录制方式，我们的『白板回放加音频回放』的组合方案具备诸多优势如下：

- 高清播放、低带宽占用。方便用流量观看、以及在校园网等网络环境不稳定的场景下观看。
- 观看时支持缩放操作（zoom in & zoom out），方便客户用手机等移动端设备观看。
- 支持在微信朋友圈、小程序等流量平台传播课程。
- 无需老师或者工作人员介入，自动在云端完成。

**创建房间时，需要设置为可回访房间，由于回放房间会占用更多资源，需要开发者主动设置。**

具体请在 [服务器文档](zh-CN/v2/server-detail-api.md) 中查看 创建白板 API**

房间有三种模式：临时房间、持久化房间、可回放房间。房间模式必须在创建时指定，一旦确定，将不可修改。这三种模式的特征如下。

## 创建回放——快速开始

```Java
Intent intent = getIntent();
final String uuid = intent.getStringExtra("uuid");
final String m3u8 = intent.getStringExtra("m3u8");

whiteBroadView = (WhiteBroadView) findViewById(R.id.playWhite);
WhiteSdk whiteSdk = new WhiteSdk(
        whiteBroadView,
        PlayActivity.this,
        new WhiteSdkConfiguration(DeviceType.touch, 10, 0.1));
PlayerConfiguration playerConfiguration = new PlayerConfiguration();
playerConfiguration.setRoom(uuid);
playerConfiguration.setAudioUrl(m3u8);

whiteSdk.createPlayer(playerConfiguration, new AbstractPlayerEventListener() {
    @Override
    public void onPhaseChanged(PlayerPhase phase) {
        showToast(gson.toJson(phase));
    }

    @Override
    public void onLoadFirstFrame() {
        showToast("onLoadFirstFrame");
    }

    @Override
    public void onSliceChanged(String slice) {
        showToast(slice);
    }

    @Override
    public void onPlayerStateChanged(PlayerState modifyState) {
        showToast(gson.toJson(modifyState));
    }

    @Override
    public void onStoppedWithError(SDKError error) {
        showToast(error.getJsStack());
    }

    @Override
    public void onScheduleTimeChanged(long time) {
        showToast(time);
    }

    @Override
    public void onCatchErrorWhenAppendFrame(SDKError error) {
        showToast(error.getJsStack());
    }

    @Override
    public void onCatchErrorWhenRender(SDKError error) {
        showToast(error.getJsStack());
    }

    @Override
    public void onCursorViewsUpdate(UpdateCursor updateCursor) {
        showToast(gson.toJson(updateCursor));
    }
}, new Promise<Player>() {
    @Override
    public void then(Player player) {
        player.play();
    }

    @Override
    public void catchEx(SDKError t) {
        Logger.error("create player error, ", t);
    }
});
```

* 以上代码，可以在 [white-demo-android](https://github.com/duty-os/white-demo-android) Demo 中的 PlayActivity 中查看。