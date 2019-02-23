# State management

White-web-sdk also offers a variety of tools such as selectors, pencils, text, round tools, and rectangular tools. Image display tools and PPT tools are also available. The presentation of these functions is related to the interaction design and visual style of the specific web application itself. With this in mind, these UI components are not directly available on the whiteboard. You can only use the functions of the whiteboard by means of program calls.

In this regard, you may have the following questions:

* My UI components are ready, how do I make the operation of the UI components affect the behavior of the whiteboard?
* What state does the whiteboard have, how does my UI component listen and get the state of the whiteboard?

This chapter will address these two issues.

# Whiteboard status

When you join a room, you can get and modify the room status as follows.

* __GlobalState__: The state of the whole room, it exists from the creation of the room. Visible to everyone, everyone can modify it.
* __MemberState__: Member status. Each room member has a separate instance that is automatically created when a member joins the room and is automatically released when the member leaves the room. Members can only get, listen to, and modify their own MemberState.
* __BroadcastState__: The angle of view state is related to the anchor mode and the follow mode.

These three states are all a key-value object.

You can get them by doing the following.

```javascript
var globalState = room.state.globalState;
var memberState = room.state.memberState;
var broadcastState = room.state.broadcastState;
```

The room object needs to be obtained by calling the `joinRoom` method, which is described in the previous chapter and will not be described here.

These two states may change passively, such as GlobalState may be modified by other members of the room. Therefore, you need to monitor their changes. This is done by calling the callback function when calling `joinRoom`.

```javascript
var callbacks = {
    onRoomStateChanged: function(modifyState) {
        if (modifyState.globalState) {
            // globalState changed
            var newGlobalState = modifyState.globalState;
        }
        if (modifyState.memberState) {
            // memberState changed
            var newMemberState = modifyState.memberState;
        }
        if (modifyState.broadcastState) {
            // broadcastState changed
            var broadcastState = modifyState.broadcastState;
        }
    },
};
room.joinRoom({uuid: uuid, roomToken: roomToken}, callbacks);
```

When you need to modify the state of the whiteboard, you can modify it as follows.

```javascript
room.setGlobalState({...});
room.setMemberState({...});
```

You don't need to pass in the modified full GlobalState or MemberState in the parameters, just fill in the key-value pairs you want to update. If you modify GlobalState, people in the entire room will receive your changes.

# GlobalState

```typescript
type GlobalState = {
    // Current scene index, modify it will switch the scene
    currentSceneIndex: number;
};
```

# MemberState

```typescript
type MemberState = {

    // The current tool, modify it will switch tools. The following tools are available for selection:
    // 1. selector
    // 2. pencil
    // 3. rectangle
    // 4. ellipse
    // 5. eraser
    // 6. text
    currentApplianceName: string;

    // Select the tool radius, the bigger the selection tool, the easier it is to click
    selectorRadius: number;

    // The color of the line, RGB is written in an array like [255, 128, 255]。
    strokeColor: [number, number, number];

    // Line thickness
    strokeWidth: number;

    // Font size
    textSize: number;
};
```

# BroadcastState

```typescript
type BroadcastState = {

    // The current perspective mode has the following:
    // 1. "freedom" free perspective, the perspective will not follow anyone
    // 2. "follower" follows the perspective and will follow the anchor in the room
    // 3. "broadcaster" anchor view, the perspective of other people in the room will follow me
    mode: ViewMode;

    // Room anchor ID.
    //Undefined if the current room has no anchor
    broadcasterId?: number;
};
```
# Switching aids

White-web-sdk provides a variety of teaching aids, we can switch the current teaching aid by modifying `memberState`. For example, to switch the current teaching aid to the "pencil" tool you can use the following code.

```javascript
room.setMemberState({
    currentApplianceName: "pencil",
});
```

The name of the teaching aid for the current room can be obtained by the following code.

```javascript
room.state.memberState.currentApplianceName
```

White-web-sdk provides the following teaching aids.

| string | description |
| :--- | :--- |
| selector | Select, move, zoom |
| pencil | Draw a colored track |
| rectangle | Draw a rectangle |
| ellipse | Draw a perfect circle or ellipse |
| eraser | Delete track |
| text | Edit, enter text |

# Palette

The color of the palette can be modified by the following code.

```javascript
room.setMemberState({
    strokeColor: [255, 0, 0],
});
```

The color of the palette is represented by writing RGB in an array of the form [255, 0, 0].

You can also get the color of the current palette according to the following code.

```javascript
room.state.memberState.strokeColor
```

The palette can affect the effects of pencils, rectangles, ellipses, and text tools.

White-web-sdk allows multiple pages. When the room was first created, there was only one blank page. We can insert/delete pages by the following methods.

```javascript
// Insert a new page in the specified index
room.insertNewPage(index: number);

// Delete page in index position
room.removePage(index: number);
```

We can do page flipping by modifying globalState.

```javascript
// Turn to page 4
var index = 3;

room.setGlobalState({
    currentSceneIndex: index,
});
```

Note that the globalState is shared by the entire room owner. Turning pages by modifying the currentState's currentSceneIndex property will cause everyone in the entire room to switch to that page.

White-web-sdk also supports inserting PPTs. The inserted PPT will become a page with PPT content. We need to convert each page of the PPT file or PDF file into a set of images separately, and publish the set of images on the Internet (for example, upload to a cloud storage repository and get the accessible URL for each image).

Then, insert this set of URLs as follows.

```javascript
room.pushPptPages([
    {src: "http://website.com/image-001.png", width: 1024, height: 1024},
    {src: "http://website.com/image-002.png", width: 1024, height: 1024},
    {src: "http://website.com/image-003.png", width: 1024, height: 1024},
]);
```

This method will insert 3 new pages with PPT content now and now.

# Follow the speaker's perspective

The whiteboard provided by white-web-sdk is infinitely extended to the four sides. It also allows the user to move the whiteboard by means of a mouse wheel, gesture, and the like. Therefore, even on the same page of the same whiteboard, the content that may be seen on different users' screens is different.

To this end, we introduce the concept of "speaker mode". The speaker mode sets a person in the room as a speaker, and what he/she sees on the screen is what everyone else sees. When the speaker zooms in and out of the perspective, other people's screens will automatically zoom and move.

In the speaker mode, the speaker is like a video camera, and others are like a television. What the speaker sees will be synced to other people's TV sets.

The mode of the current angle of view can be modified as follows.

```typescript
// Speaker mode
// The perspective mode of others in the room is automatically modified to follower and forcing to view your perspective.
// If there is another speaker in the room, the speaker's perspective mode will also be forced to change to follower.
// It's as if you grabbed his/her speaker position.
room.setViewMode("broadcaster");

// Free mode
// You are free to zoom and move your perspective.
// Even if there is a speaker in the room, the speaker can't influence your perspective.
room.setViewMode("freedom");

// Follow mode
// You will follow the speaker's perspective. Where the speaker is watching, you will follow where to look
// In this mode, if you zoom in and move the angle of view, it will automatically switch back to freedom mode.
room.setViewMode("follower");
```

We can also get the status of the current perspective by the following method.

```typescript
room.state.broadcastState
```

Its structure is as follows.

```typescript
export type BroadcastState = {

    // The current perspective mode has the following:
    // 1. "freedom" free perspective, the perspective will not follow anyone
    // 2. "follower" follows the perspective and will follow the speaker in the room
    // 3. "broadcaster" Speaker's perspective, the perspective of others in the room will follow me
    mode: ViewMode;

    // Room speaker ID.。
    // Undefined if there is no speaker in the current room
    broadcasterId?: number;
};
```

# Perspective center

The different screen sizes of different users in the same room may be inconsistent, which will result in their whiteboards having different sizes. In fact, other users in the room will point the center of the whiteboard to the speaker's whiteboard center (note that the screen size of the speaker and other users is not necessarily the same).

We need to set the size of the whiteboard as follows so that the speaker can synchronize its view center.

```
room.setViewSize(1024, 768);
```

The size should be the same as the actual size of the whiteboard on the page (generally the size of the browser page). If the user resizes the window, the whiteboard size changes. This method should be recalled to refresh the size.


- You can disable the user from manipulating the whiteboard with `room.disableOperations = true`.
- You can restore the user's ability to manipulate the whiteboard with `room.disableOperations = false`.
