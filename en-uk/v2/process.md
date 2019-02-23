# Best Practices

We will briefly explain the best way to use it.

## Business description

We implement a set of user systems ourselves, and the user logs in with a username and password. Users can create a whiteboard (room). Then he can enter the room and write and draw on the whiteboard. At the same time, he can share the room with other users. After receiving the invitation, you can enter the room by invitation. Then interact with the rest of the room.

## Achieve

After logging in to our own user system, the user needs to invoke the "create whiteboard" API of the business server. After the service server authenticates, it determines that the user has the permission to create a whiteboard, and then calls the White API through the Mini Token to create a room. The business server then passes the room's `uuid` and `roomToken` to the user.

After the user gets the `uuid` and `roomToken`, they call the API of the client SDK to enter the room.

Subsequently, the user wishes to share this room with other users. He/she calls the "Share to Others" API of the business server and passes the room's `uuid` to the business server. The business server generates multiple invitation notifications to other users. Both the `uuid` and `roomToken` are included in the invitation notification.

After other users receive the invitation notification, they pass the `uuid` and `roomToken` and then call the API of the client SDK to enter the room.
