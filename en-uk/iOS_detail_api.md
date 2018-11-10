# Our solution

* Provide a real-time interactive whiteboard that is easy to integrate and powerful.
* The whiteboard provides flexible scalability and secondary development capabilities, providing a full platform (iOS, Android, Web, applet) SDK.

# Whiteboard teaching aids and status

* My UI components are ready, how do I make the operation of the UI components affect the behavior of the whiteboard?
* What state does the whiteboard have, how does my UI component listen and get the state of the whiteboard ?

When you join a room, you can get and modify the room status mainly as follows:

* __GlobalState__: The state of the whole room, it exists from the creation of the room. Visible to everyone, everyone can modify it.
* __MemberState__: Member status. Each room member has a separate instance that is automatically created when a member joins the room and is automatically released when the member leaves the room. Members can only get, listen to, and modify their own MemberState.
* __BroadcastState__: The angle of view state is related to the anchor mode and the follow mode.

The event notification API can be viewed in `WhiteRoomCallbacks.h`.
The API for setting status and getting status can be viewed in `WhiteRoom.h`.
*Each active setting API will be followed by the key classes that need to be viewed.* 

## Tool list

| name | objective-C constant | script |
| :--- | :--- | :--- |
| selector | ApplianceSelector | Select, move, zoom |
| pencil | AppliancePencil | Draw a colored track |
| rectangle | ApplianceRectangle | Draw a rectangle |
| ellipse | ApplianceEllipse | Draw a perfect circle or ellipse |
| eraser | ApplianceEraser | Delete track |
| text | ApplianceText | Edit, enter text |

## Switch tool

* The White SDK provides a variety of teaching aids, and we can set the current teaching aid by generating a `WhiteMemberState` instance.
* For example, to switch the current teaching aid to the "pencil" tool, you can use the following code:

```objectivec
WhiteMemberState *memberState = [[WhiteMemberState alloc] init];
// When the whiteboard is in the initial state, the teaching aid defaults to the brush pencil.
// You can see the various teaching aid constants currently available in WhiteMemeberState.h
memberState.currentApplianceName = AppliancePencil;
[whiteRoom setMemberState:memberState];
```

## Set the aid color, thickness
`WhiteMemberState` There are other attributes:

```objectivec
@interface WhiteMemberState : WhiteObject
/** 传入格式为[@(0-255),@(0-255),@(0-255)]的RGB */
@property (nonatomic, copy) NSArray<NSNumber *> *strokeColor;
/** 画笔粗细 */
@property (nonatomic, strong) NSNumber *strokeWidth;
```

1. The `strokeColor` property allows you to adjust the color of the teaching aid. This property can affect the color of pencils, rectangles, ellipses, and text tools.
2. The `strokeWidth` property allows you to adjust the thickness of the teaching aid. This property can affect the color of pencils, rectangles, ellipses, and text tools.

## Get current teaching aids

```objectivec
[whiteRoom getMemberStateWithResult:^(WhiteMemberState *state) {
    NSLog(@"%@", [state jsonString]);
}];
```

## Subscribe to the whiteboard status

See WhiteRoomCallbackDelegate

* Callback API list:

```objectivec
@protocol WhiteRoomCallbackDelegate <NSObject>
/** Whiteboard network connection status callback */
- (void)firePhaseChanged:(WhiteRoomPhase)phase;
/** Callback when any whiteboard RoomValue property variable changes */
- (void)fireRoomStateChanged:(WhiteRoomState *)magixPhase;
- (void)fireBeingAbleToCommitChange:(BOOL)isAbleToCommit;
/** Whiteboard loses connection callback, with reason */
- (void)fireDisconnectWithError:(NSString *)error;
/** The user is kicked out of the room by the remote server with the reason */
- (void)fireKickedWithReason:(NSString *)reason;
/** User error event capture */
- (void)fireCatchErrorWhenAppendFrame:(NSUInteger)userId error:(NSString *)error;

@end
```

* When is the delegate passed?

When calling the following API to generate the SDK, the incoming `callbacks` parameter needs to implement the above protocol. You can accept callbacks when an event occurs.

```objectivec
- (void)joinRoomWithRoomUuid:(NSString *)roomUuid roomToken:(NSString *)roomToken callbacks:(id<WhiteRoomCallbackDelegate>)callbacks completionHandler:(void (^) (BOOL success, WhiteRoom *room, NSError *error))completionHander;
```

__Note: Calling the `WhiteRoom` API to set the room state also triggers an event callback.__

# PPT and page turning

Reference WhitePptPage and WhiteGlobalState

## Insert PPT

The White SDK also supports plugging in PPT. The inserted PPT will become a page with PPT content. We need to convert each page of the PPT file or PDF file into a set of images separately, and publish the set of images on the Internet (for example, upload to a cloud storage repository and get the accessible URL for each image).

```objectivec
WhitePptPage *pptPage = [[WhitePptPage alloc] init];
pptPage.src = @"https://www.xxx.com/1.png";
pptPage.width = 600;
pptPage.height = 600;
// Always an array
[self.room pushPptPages:@[pptPage]];
```

*The inserted PPT will not be displayed immediately, but will automatically create multiple whiteboard pages, but it will remain on the current page and can be switched through the paging API.* 

## Get PPT

Getting a PPT returns the URL of each PPT images.

```objectivec
[self.room getPptImagesWithResult:^(NSArray<NSString *> *pptPages) {
    NSLog(@"%@", pptPages);
}];
```

## Page turning

Reference `WhiteGlobalState`

After the PPT is inserted, the White SDK creates multiple pages (the default is still on the current page) and allows switching between them.

When the whiteboard is first created, there is only one blank page. We can insert, delete, and switch pages by the following methods.

__Note that the globalState is shared by the entire room owner. Turning pages by modifying the currentState's currentSceneIndex property will cause everyone in the entire room to switch to that page.__ 

```objectivec
// Switch page
WhiteGlobalState *state = [[WhiteGlobalState alloc] init];
state.currentSceneIndex = [magixPhase.pptImages count] - 1;
[self.room setGlobalState:state];

// At index 1, insert a new blank page
[self.room insertNewPage:1];
// Remove index 1 page
[self.room removePage:1]
```

# Anchor mode

See WhiteBroadcastState.

The whiteboard provided by the White SDK is infinitely extended to the four sides. It also allows the user to move the whiteboard by means of a mouse wheel, gesture, and the like. Therefore, even on the same page of the same whiteboard, the content that may be seen on different users' screens is different.

To this end, we introduce the concept of "host mode". The anchor mode sets an individual in the room as the anchor, and what he/she sees on the screen is what everyone else sees. When the anchor zooms and moves the angle of view, other people's screens will automatically zoom and move.

In the anchor mode, the anchor is like a video camera, and everyone else is like a TV. What the anchor sees will be synced to other people's TVs.

## Modify anchor mode

You can modify the anchor mode by generating the `WhiteBroadcast` class, setting the `viewMode` enumeration property, and passing it to WhiteRoom.

Specific code reference

```objectivec
typedef NS_ENUM(NSInteger, WhiteViewMode) {
    // Free mode
    // You are free to zoom and move your perspective.
    // Even if there is an anchor in the room, the anchor can't affect your perspective.
    WhiteViewModeFreedom,
    // Follow mode
    // You will follow the perspective of the anchor. Where the anchor is watching, you will follow where to look.
    // In this mode, if you zoom in and move the angle of view, it will automatically switch back to freedom mode.
    WhiteViewModeFollower,
    // Anchor mode.
    // The perspective mode of others in the room is automatically modified to follower and forcing to view your perspective.
    // If there is another anchor in the room, the perspective mode of the anchor will also be forced to change to follower.
    // It's as if you grabbed his/her anchor location.
    WhiteViewModeBroadcaster,
};

// Modify perspective mode
WhiteBroadcastState *state = [[WhiteBroadcastState alloc] init];
[self.room setViewMode:state];
```

## Get current view state

```objectivec
[self.room getBroadcastStateWithResult:^(WhiteBroadcastState *state) {
    NSLog(@"%@", [state jsonString]);
}];
```

# Perspective center

The different screen sizes of different users in the same room may be inconsistent, which will result in their whiteboards having different sizes. In fact, other users in the room will align the center of the whiteboard with the center of the anchor's whiteboard (note that the screen size of the anchor and other users are not necessarily the same).

We need to set the size of the whiteboard as follows so that the anchor can synchronize its view center.

```objectivec
[room setViewSizeWithWidth:100 height:100];
```

The size should be the same as the actual size of the whiteboard in the product (generally the size of the browser page or application screen). If the user resizes the window, the whiteboard size changes. This method should be recalled to refresh the size.


