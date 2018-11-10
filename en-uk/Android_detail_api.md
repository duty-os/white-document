# Our solution

* Provide a real-time interactive whiteboard that is easy to integrate and powerful.
* The whiteboard provides flexible scalability and secondary development capabilities, providing a full platform (iOS, Android, Web, applet) SDK.

# Tool

## Switch tool

The White SDK provides a variety of teaching aids, and we can switch between the current teaching aids by modifying `memberState`. For example, to switch the current teaching aid to the "pencil" tool you can use the following code.

```java
MemberState memberState = new MemberState();
memberState.setCurrentApplianceName("pencil");
room.setMemberState(memberState);
```

The name of the teaching aid for the current room can be obtained by the following code.

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

## Tool list

| string | description |
| :--- | :--- |
| selector | Select, move, zoom |
| pencil | Draw a colored track |
| rectangle | Draw a rectangle |
| ellipse | Draw a perfect circle or ellipse |
| eraser | Delete track |
| text | Edit, enter text |


## Palettes

The color of the palette can be modified by the following code.

```java
MemberState memberState = new MemberState();
memberState.setStrokeColor(new int[]{255, 0, 0});
room.setMemberState(memberState);
```

The color of the palette is represented by writing RGB in an array of the form [255, 0, 0].

You can also get the color of the current palette according to the following code.

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

The palette can affect the effects of pencils, rectangles, ellipses, and text tools.

# Page turning and PPT

The White SDK allows multiple pages to be swapped in. When the whiteboard is first created, there is only one blank page. We can insert/delete pages by the following methods.

```java
// Insert a new page in the specified index
room.insertNewPage(1);

// Delete page in index position
room.removePage(1);
```

We can do page flipping by modifying globalState.

```java
GlobalState globalState = new GlobalState();
globalState.setCurrentSceneIndex(1);
room.setGlobalState(globalState);
```

Note that the globalState is shared by the entire room owner. Turning pages by modifying the currentState's currentSceneIndex property will cause everyone in the entire room to switch to that page.

The White SDK also supports plugging in PPT. The inserted PPT will become a page with PPT content. We need to convert each page of the PPT file or PDF file into a set of images separately, and publish the set of images on the Internet (for example, upload to a cloud storage repository and get the accessible URL for each image). 

Then, insert this set of URLs as follows.

```java
room.pushPptPages(new PptPage[]{
    new PptPage("http://website.com/image-001.png", 600d, 600d),
    new PptPage("http://website.com/image-002.png", 600d, 600d),
    new PptPage("http://website.com/image-003.png", 600d, 600d)
});
```

This method will insert 3 new pages with PPT content after the current page.

# Anchor mode

## Follow the anchor's perspective

The whiteboard provided by the White SDK is infinitely extended to the four sides. It also allows the user to move the whiteboard by means of a mouse wheel, gesture, and the like. Therefore, even on the same page of the same whiteboard, the content that may be seen on different users' screens is different.

To this end, we introduce the concept of "host mode". The anchor mode sets an individual in the room as the anchor, and what he/she sees on the screen is what everyone else sees. When the anchor zooms and moves the angle of view, other people's screens will automatically zoom and move.

In the anchor mode, the anchor is like a video camera, and everyone else is like a TV. What the anchor sees will be synced to other people's TVs.

The mode of the current angle of view can be modified as follows.

```java
// Anchor mode
// The perspective mode of others in the room is automatically modified to follower and forcing to view your perspective.
// If there is another anchor in the room, the perspective mode of the anchor will also be forced to change to follower.
// It's as if you grabbed his/her anchor location.
room.setViewMode(ViewMode.broadcaster);

// Free mode
// You are free to zoom and move your perspective.
// Even if there is an anchor in the room, the anchor can't affect your perspective.
room.setViewMode(ViewMode.freedom);

// Follow mode
// You will follow the perspective of the anchor. Where the anchor is watching, you will follow where to look.
// In this mode, if you zoom in and move the angle of view, it will automatically switch back to freedom mode.
room.setViewMode(ViewMode.follower);
```

We can also get the status of the current perspective by the following method.


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

Its structure is as follows.

```java
public class BroadcastState {
    private ViewMode mode;
    private Long broadcasterId;
    private MemberInformation broadcasterInformation;
    
    ... getter/setter
}
```

## Perspective center

The different screen sizes of different users in the same room may be inconsistent, which will result in their whiteboards having different sizes. In fact, other users in the room will align the center of the whiteboard with the center of the anchor's whiteboard (note that the screen size of the anchor and other users are not necessarily the same).

We need to set the size of the whiteboard as follows so that the anchor can synchronize its view center.

```java
room.setViewSize(100, 100);
```

The size should be the same as the actual size of the whiteboard in the product (generally the size of the browser page or application screen). If the user resizes the window, the whiteboard size changes. This method should be recalled to refresh the size.

# Whiteboard status management

The White SDK also offers a variety of tools such as selectors, pencils, text, round tools, and rectangular tools. Image display tools and PPT tools are also available. The presentation of these functions is related to the interaction design and visual style of the specific web application itself. With this in mind, these UI components are not directly available on the whiteboard. You can only use the functions of the whiteboard by means of program calls.

In this regard, you may have the following questions:
 
* My UI components are ready, how do I make the operation of the UI components affect the behavior of the whiteboard?
* What state does the whiteboard have, how does my UI component listen and get the state of the whiteboard?

This chapter will address these two issues.

## Whiteboard status introduction

When you join a room, you can get and modify the room status as follows.

* __GlobalState__: The state of the whole room, it exists from the creation of the room. Visible to everyone, everyone can modify it.
* __MemberState__: Member status. Each room member has a separate instance that is automatically created when a member joins the room and is automatically released when the member leaves the room. Members can only get, listen to, and modify their own MemberState.
* __BroadcastState__: The angle of view state is related to the anchor mode and the follow mode.

These three states are all a key-value object.

You can get them by doing the following.

```java
room.getGlobalState(new Promise<GlobalState>() {
    @Override
    public void then(GlobalState globalState) {}
    @Override
    public void catchEx(Exception e) {}
});
room.getMemberState(new Promise<MemberState>() {
    @Override
    public void then(MemberState memberState) {}
    @Override
    public void catchEx(Exception e) {}
});
room.getBroadcastState(new Promise<BroadcastState>() {
    @Override
    public void then(BroadcastState broadcastState) {}
    @Override
    public void catchEx(Exception t) {}
});
```

The room object needs to be obtained by calling the `joinRoom` method, which is described in the previous chapter and will not be described here.

These two states may change passively, such as GlobalState may be modified by other members of the room. Therefore, you need to monitor their changes. To do this, register the listener on `WhiteSDK`, register `RoomCallbacks` or `AbstractRoomCallbacks` , and use the latter to override only the callback methods of interest.

```java
whiteSdk.addRoomCallbacks(new RoomCallbacks() {
    @Override
    public void onPhaseChanged(RoomPhase roomPhase) {}
    @Override
    public void onBeingAbleToCommitChange(boolean b) {}
    @Override
    public void onDisconnectWithError(Exception e) {}
    @Override
    public void onKickedWithReason(String s) {}
    @Override
    public void onRoomStateChanged(RoomState roomState) {}
    @Override
    public void onCatchErrorWhenAppendFrame(long l, Exception e) {}
});
```

When you need to modify the state of the whiteboard, you can modify it as follows.

```java
MemberState memberState = new MemberState();
memberState.setStrokeColor(new int[]{99, 99, 99});
memberState.setCurrentApplianceName("rectangle");
room.setMemberState(memberState);
```

You don't need to pass in the modified full GlobalState or MemberState in the parameters, just fill in the key-value pairs you want to update. If you modify GlobalState, people in the entire room will receive your changes.

## GlobalState

```java
public class GlobalState {
    // Current scene index, modify it will switch the scene
    private Integer currentSceneIndex;
    ... setter/getter
}
```

## MemberState

```java
public class MemberState {
    // The current tool, modify it will switch tools. The following tools are available for selection:
    // 1. selector
    // 2. pencil
    // 3. rectangle
    // 4. ellipse
    // 5. eraser
    // 6. text
    private String currentApplianceName;
    // The color of the line, RGB is written in an array. The shape is [255, 128, 255].
    private int[] strokeColor;
    // Line thickness
    private Double strokeWidth;
    // Font size
    private Double textSize;
    ... setter/getter
}
```

## BroadcastState

```java
public class BroadcastState {
    // The current perspective mode has the following:
    // 1. "freedom" free perspective, the perspective will not follow anyone
    // 2. "follower" follows the perspective and will follow the anchor in the room
    // 3. "broadcaster" anchor view, the perspective of other people in the room will follow me
    private ViewMode mode;

    // Room anchor ID.
    // Undefined if the current room has no anchor
    private Long broadcasterId;

    // The anchor information can be customized. For details, see the data structure below.
    private MemberInformation broadcasterInformation;
    ... setter/getter
}

public class MemberInformation {
    // ID
    private Long id;
    // Nickname
    private String nickName;
    // Avatar URL
    private String avatar;
    ... setter/getter
}
```

