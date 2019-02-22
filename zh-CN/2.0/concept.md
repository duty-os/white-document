# 概念详解

本章将介绍 White 的相关概念，了解这些概念将有助于更加合理地使用 White 提供的功能和服务，从而帮助你开发出更加完美的网站和应用。我们假设你已经在[《快速开始》](./js_quickstart.md)章节中自己动手，构建起了自己的第一个白板应用。假如你还没有阅读[《快速开始》](./js_quickstart.md)，强烈建议你在阅读和实践之后，再开始阅读本章节。

# 客户身份凭证 Mini Token

White 同时为许许多多客户提供服务，每一个客户通过持有独一无二的 Mini Token 来作为凭证。Mini Token 将与你的企业账号绑定。

你可以在 [console.herewhite.com](https://console.herewhite.com) 注册自己的企业账号。

![屏幕快照 2018-08-17 15.22.47.png | left | 747x724](./_images/console_login.jpg)

在「设置」中，可以获取帐号的 Mini Token。

![屏幕快照 2018-08-17 15.25.13.png | center | 747x394](./_images/consle_key.jpg)

__注意：Mini Token 是 White 和你的业务服务器通讯的凭证，请勿以任何形式对外泄漏。__

你“__不应该”__将 Mini Token 写入客户端 / 网页的代码中，因为别人可能通过反编译你的客户端代码获取 Mini Token。业务服务器的任何公开 API 都不应该返回 Mini Token，以防他人通过伪造客户端的方式获取 Mini Token。更不要将 Mini Token 直接公布在网站上，或通过 IM 或 email 传给外界。

你“__可以”__将 Mini Token 写入业务服务器的代码中，或服务端的配置文件中。只要你能确保服务器的代码和配置文件不会被外界获取，那么 Mini Token 就是安全的。

# 房间
White 的服务核心是房间。一个白板对应一个房间，一个房间可以加入多个客户端。你的业务服务器使用 Mini Token 创建房间，White 的服务器将返回该房间的 `uuid` 和 `roomToken` 。

## uuid
房间的唯一标识符，是一个字符串。通过它可以定位到房间。这是房间很重要的一个属性，和房间有关的所有 API 调用都要用到它。

## Room Token
每一个房间都有自己的 `roomToken` ，不同房间的 `roomToken` 是不一样的。客户端只有持有特定房间的 `roomToken` 才能进入。

业务服务器可以通过它来实现鉴权。具体做法是，先通过业务逻辑确定客户端是否有资格进入特定房间。如果有资格，则将该房间的 `roomToken` 通过网络传给客户端。客户端拿到 `roomToken` 调用自己的客户端 SDK 进入该房间。

由于 `roomToken` 必须用 Mini Token 获取，因此，客户端是无法伪造 `roomToken` 的。

# 时序图

![屏幕快照 2018-08-17 15.25.13.png | center | 747x394](./_images/white_desgin.svg)

