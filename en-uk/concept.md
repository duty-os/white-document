# Detailed concept

This chapter introduces the concepts of White, and understanding these concepts will help you use the features and services provided by White to help you develop more perfect websites and applications. Let's assume that you built your own first whiteboard application in the Quick Start chapter. If you haven't read the Quick Start section yet, it is highly recommended that you read this chapter after reading and practicing.

# Customer ID Mini Token

White also serves a wide range of clients, each of whom holds a unique Mini Token as a credential. Mini Token will be tied to your business account.

You can be at [console.herewhite.com](https://console.herewhite.com) register your own business account.

![屏幕快照 2018-08-17 15.22.47.png | left | 747x724](https://cdn.nlark.com/yuque/0/2018/png/103701/1534490655547-6e0a49b6-4811-4219-a157-fa40f7546bcb.png "")

In Settings, you can get the Mini Token for your account.

![屏幕快照 2018-08-17 15.25.13.png | center | 747x394](https://cdn.nlark.com/yuque/0/2018/png/103701/1534490808533-1f83bcb9-d151-400d-95c0-7e1d3deed54a.png "")

__Note: Mini Token is the credential for White to communicate with your business server. Do not leak in any form.__

You __should not__ write the Mini Token to the client/web page code because someone else might get the Mini Token by decompiling your client code. Any public API of the business server should not return a Mini Token in case someone else gets the Mini Token by forging the client. Don't post the Mini Token directly on the website or pass it to the outside world via IM or email.

You __should__ Write the Mini Token to the code of the business server, or to the configuration file of the server. Mini Token is safe as long as you can ensure that the server's code and configuration files are not available to the outside world.

# room

The core of White's service is the room. One whiteboard corresponds to one room, and one room can join multiple clients. Your business server uses Mini Token to create a room, and White's server will return `uuid` and `roomToken` for that room.

## uuid

The unique identifier of the room is a string. It can be used to locate the room. This is a very important property of the room, and it is used for all API calls related to the room.

## Room Token

Every room has its own `roomToken`, and the `roomToken` in different rooms is different. The client can only enter if it has a `roomToken` for a specific room.

The business server can use it to achieve authentication. The specific approach is to first determine through the business logic whether the client is eligible to enter a specific room. If eligible, pass the room's `roomToken` to the client over the network. The client gets `roomToken` and calls its own client SDK to enter the room.

Since `roomToken` must be obtained with Mini Token, the client cannot forge `roomToken`.

# Timing diagram

<div id="wgezvu" data-type="puml" data-display="block" data-align="center" data-src="https://cdn.nlark.com/__puml/1703448d1402b83c5e72086a4918ac52.svg" data-width="479" data-height="237" data-text="%40startuml%0A%0Aautonumber%0A%0A%E5%AE%A2%E6%88%B7%E7%AB%AF%20-%3E%20%E4%B8%9A%E5%8A%A1%E6%9C%8D%E5%8A%A1%E5%99%A8%3A%20%E5%88%9B%E5%BB%BA%E7%99%BD%E6%9D%BF%0A%0A%E4%B8%9A%E5%8A%A1%E6%9C%8D%E5%8A%A1%E5%99%A8%20-%3E%20White%3A%20%E5%88%9B%E5%BB%BA%E7%99%BD%E6%9D%BF%EF%BC%88createRoom%EF%BC%89%0A%0AWhite%20--%3E%20%E4%B8%9A%E5%8A%A1%E6%9C%8D%E5%8A%A1%E5%99%A8%3A%20%E8%BF%94%E5%9B%9ERoomToken%E5%92%8Cuuid%0A%0A%E4%B8%9A%E5%8A%A1%E6%9C%8D%E5%8A%A1%E5%99%A8%20-%3E%20%E4%B8%9A%E5%8A%A1%E6%95%B0%E5%BA%93%3A%20%E8%AE%B0%E5%BD%95%E7%99%BD%E6%9D%BFuuid%0A%0A%E4%B8%9A%E5%8A%A1%E6%9C%8D%E5%8A%A1%E5%99%A8%20--%3E%20%E5%AE%A2%E6%88%B7%E7%AB%AF%3A%20%E8%BF%94%E5%9B%9ERoomToken%E5%92%8Cuuid%0A%0A%E5%AE%A2%E6%88%B7%E7%AB%AF%20-%3E%20%E5%AE%A2%E6%88%B7%E7%AB%AFSDK%3A%20%E5%BB%BA%E7%AB%8B%E8%BF%9E%E6%8E%A5%EF%BC%88joinRoom%EF%BC%89%0A%0A%E5%AE%A2%E6%88%B7%E7%AB%AFSDK%20-%3E%20White%3A%20%E5%BB%BA%E7%AB%8B%E8%BF%9E%E6%8E%A5%0A%0A%40enduml"><img src="https://cdn.nlark.com/__puml/1703448d1402b83c5e72086a4918ac52.svg" width="479"/></div>


