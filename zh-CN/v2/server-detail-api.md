<span data-type="color" style="color:rgb(51, 51, 51)"><span data-type="background" style="background-color:rgb(255, 255, 255)">REST API 可以让你用任何支持发送 HTTP 请求的设备来与 White 进行交互。</span></span>

# API 请求域名

## v1.0 版本

```plain
https://cloudcapiv3.herewhite.com
```

## v2.0 版本

```plain
https://cloudcapiv4.herewhite.com
```

# 网络请求

## 全局使用参数

* token 参数

用户验证通过通过 URL 参数中的 token 进行验证，token 来源参考：[快速开始](/zh-CN/v2/js-quickstart.md)


## 请求格式
对于 POST 和 PUT 请求，请求的主体必须是 JSON 格式，而且 HTTP header 的 Content-Type 需要设置为 `application/json`


## 响应格式
对于所有的请求，响应格式都是一个 JSON 对象。

一个请求总会包含 code 字段，200 表示成功，成功的响应附带一个 msg 字段表示具体业务的返回内容：
```json
{
    "code": 200,
    "msg": {
        "room": {
            "id": 10987,
            "name": "111",
            "limit": 100,
            "teamId": 1,
            "adminId": 1,
            "uuid": "5d10677345324c0cb3febd3291e2a607",
            "updatedAt": "2018-08-14T11:19:04.895Z",
            "createdAt": "2018-08-14T11:19:04.895Z"
        },
        "hare": "{\"message\":\"ok\"}",
        "roomToken": "xx"
    }
}
```

<span data-type="color" style="color:rgb(51, 51, 51)"><span data-type="background" style="background-color:rgb(255, 255, 255)">当一个请求失败时响应的主体仍然是一个 JSON 对象，但是总是会包含 </span></span>`code`<span data-type="color" style="color:rgb(51, 51, 51)"><span data-type="background" style="background-color:rgb(255, 255, 255)"> </span></span>和 `msg`<span data-type="color" style="color:rgb(51, 51, 51)"><span data-type="background" style="background-color:rgb(255, 255, 255)"> </span></span>这两个字段，你可以用它们来进行调试，举个例子：
```json
{
  "code": 112,
  "msg": "require uuid"
}
```

# API 列表

功能 |URL | HTTP Method | HTTP Body | 请求信息 | 返回备注 
----|----|-------------|-----------|----|----

删除白板 | `/room/close?token={{token}}` | POST | {"uuid":uuid} | uuid : 白板 uuid | 暂无 
获取白板封面 | `/handle/room/snapshot?token={{token}}` | POST | {<br>"width": 600,<br>"height": 800,<br>"uuid": uuid,<br>"scene": 1<br>} | uuid: 白板 uuid；width,height 为截取白板的宽高；<br>scene : 截取页面的 index；<br>（该值为可选，如果不传，则返回白板当前页面。） | 正常请求返回一张图片，需要自行保存；当传入scene超出范围时，会返回文本信息，提示超出页面范围 
获取范围内的白板封面 | `/handle/room/snapshot/range?token={{token}}` | POST | {<br>"width": 600,<br>"height": 800,<br>"uuid": uuid,<br>"start": 0,<br>"end": 0<br>} | uuid: 白板 uuid；width,height 为截取白板的宽高；<br>start : 截取页面的开始 index；<br>end : 截取页面的结束 index；<br> | 返回范围内的所有图片的存储信息（需要在 console 配置存储驱动，请联系客户支持团队）
禁用和恢复白板 | ```/banRoom?token={{token}}``` | POST | {<br/>  "ban": false,<br/>"uuid": uuid <br/>} |uuid: 白板 uuid；ban 是否禁用，true 为禁用，false 为恢复|
获取白板当前页数 | ```/room/scenes/count?roomuuid={{roomuuid}}&token={{token}}``` | GET | 无 | 返回白板当前页数

## 创建白板

`POST /room?token={{token}}`

* body参数

字段 | 类型 | 描述 |
--  | -- | -- |
name | string | 白板名称|
limit | number | 白板最大人数；为0时，不限制人数 | 
mode | string | **v2版本参数**；房间类型：`transitory`,`persistent`,`historied` |

* 房间类型：

房间有三种模式：临时房间、持久化房间、可回放房间。房间模式必须在创建时指定，一旦确定，将不可修改。这三种模式的特征如下。

|    模式    | 可持久化 | 可回放 |                            描述                            |
| :--------: | :------: | :----: | :--------------------------------------------------------: |
|  临时房间  |     ✘    |    ✘   |  仅临时存在的房间。房间无人状态持续一段时间后将自动释放。  |
| 持久化房间（默认） |    ✓     |   ✘   |        即便房间将永久存在，除非调用 API 手动删除。         |
| 可回放房间 |    ✓     |   ✓    | 同「持久化房间」。并且房间所有内容将被自动录制，以供回放。 |

* body 例子
```json
{
    "name":"白板名称",
    "limit":100,
    "mode": "persistent"
}
```

<details>
<summary>response</summary>

```JSON
{
    "code": 200,
    "msg": {
        "room": {
            "id": 650,
            "name": "console-room",
            "limit": 100,
            "teamId": 1,
            "adminId": 1,
            "mode": "persistent",
            "template": "meeting",
            "region": "cn",
            "uuid": "此处为房间 uuid",
            "updatedAt": "2019-01-15T09:12:05.974Z",
            "createdAt": "2019-01-15T09:12:05.974Z"
        },
        "hare": "{\"uuid\":\"uuid\",\"teamId\":\"1\",\"mode\":\"persistent\",\"region\":\"cn\",\"isBan\":false,\"beginTimestamp\":1547543526200,\"endTimestamp\":1547543526200,\"endFrameId\":0,\"usersMaxCount\":100,\"survivalDuration\":30000,\"chunkFramesCount\":700,\"snapshotIdInterval\":80}",
        "roomToken": "此处为房间 roomToken",
        "code": 201
    }
}
```

</details>

## 获取白板列表

`GET /room?offset={{offset}}&limit={{limit}}&token={{token}}`

* query 参数

字段 | 类型 | 描述 |
--  | -- | -- |
offset | number | 第几块白板开始查找(从1开始计数) |
limit | number | 每次获取白板的个数 |


## 获取白板详细信息

`GET /room/id?uuid={{uuid}}&token={{token}}`

* query 参数

字段 | 类型 | 描述 |
--  | -- | -- |
uuid | string | 白板唯一标识符 |

<details><summary>response</summary>

```JSON
{
    "code": 200,
    "msg": {
        "id": 11600,
        "teamId": 1,
        "adminId": 1,
        "uuid": "此处为uuid",
        "name": "未命名",
        "limit": 10,
        "current": 0,
        "enable": true,
        "playable": false,
        "videoready": false,
        "mode": null,
        "region": "cn",
        "template": null,
        "createdAt": "2018-08-20T14:57:13.000Z",
        "updatedAt": "2018-08-26T05:56:36.000Z"
    }
}
```
</details>

## 加入特定白板

`POST /room/join?uuid={{uuid}}&token={{token}}`

* query 参数

字段 | 类型 | 描述 |
--  | -- | -- |
uuid | string | 白板唯一标识符 |

该请求的 response 中，在 `msg` 字段中，可以获取到需要的 `roomToken` 字段。

## 获取白板页数

`GET /room/scenes/count?roomuuid={{uuid}}&token={{token}}	`

* query 参数

字段 | 类型 | 描述 |
--  | -- | -- |
roomuuid | string | 白板唯一标识符 |

## 白板封面

### 特定页面封面

#### v1.0 版本

`POST /handle/room/snapshot?token={{token}}`

* body 参数

字段 | 类型 | 描述 |
--  | -- | -- |
width | string | 封面宽 |
height | string | 封面高 |
uuid | string | 白板唯一标识符 |
scene（可选） | number | 白板页面位置（默认当前页） |

#### v2.0 版本

近期推出

### 范围内封面

#### v1.0 版本

`POST /handle/room/snapshot/range?token={{token}}`

* body 参数

字段 | 类型 | 描述 |
--  | -- | -- |
width | string | 封面宽 |
height | string | 封面高 |
uuid | string | 白板唯一标识符 |
start | number | 截取页面的开始 index |
end | number | 截取页面的结束 index |

**注意：需要在 console 配置存储驱动，请联系客户支持团队**

#### v2.0 版本

近期推出

## 禁用和恢复白板

`POST /banRoom?token={{token}}`

* body 参数

字段 | 类型 | 描述 |
--  | -- | -- |
ban | boolean | true为禁用；false为恢复 |
uuid | string | 白板唯一标识符 |

## 删除白板

`POST /room/close?token={{token}}`

* body参数

字段 | 类型 | 描述 |
--  | -- | -- |
uuid | string | 白板唯一标识符 |

## v1.0版本 Postman 配置文件
如你也像我们一样使用 Postman 调试 API，恭喜这里有份 Postman 文件。可以导入（import）进你的 Postman 来协作调试。
[download: White Open API.postman_collection.json](https://sdk.herewhite.com/postman/White%20Open%20API.postman_collection.json  "size:5980")
*请替换其中的 token 为注册后得到的 token。*

# 业务服务器和 White 的关系
<div id="eiwrfi" data-type="puml" data-display="block" data-align="left" data-src="https://cdn.nlark.com/__puml/c2e1819cdafcd7c0fa9130187da08aee.svg" data-width="656" data-height="300" data-text="%40startuml%0A%0Aautonumber%0A%0A%E5%AE%A2%E6%88%B7%E4%BA%A7%E5%93%81%20-%3E%20%E5%AE%A2%E6%88%B7%E4%B8%9A%E5%8A%A1%E6%9C%8D%E5%8A%A1%3A%20%E5%88%9B%E5%BB%BA%E7%99%BD%E6%9D%BF%0A%0A%E5%AE%A2%E6%88%B7%E4%B8%9A%E5%8A%A1%E6%9C%8D%E5%8A%A1%20-%3E%20White%E4%BA%91%3A%20%E5%88%9B%E5%BB%BA%E7%99%BD%E6%9D%BF%EF%BC%88createRoom%EF%BC%89%0A%0AWhite%E4%BA%91%20--%3E%20%E5%AE%A2%E6%88%B7%E4%B8%9A%E5%8A%A1%E6%9C%8D%E5%8A%A1%3A%20%E8%BF%94%E5%9B%9ERoomToken%E5%92%8Cuuid%0A%0A%E5%AE%A2%E6%88%B7%E4%B8%9A%E5%8A%A1%E6%9C%8D%E5%8A%A1%20-%3E%20%E5%AE%A2%E6%88%B7%E4%B8%9A%E5%8A%A1%E6%95%B0%E6%8D%AE%E5%BA%93%3A%20%E8%AE%B0%E5%BD%95%E7%99%BD%E6%9D%BFuuid%0A%0A%E5%AE%A2%E6%88%B7%E4%B8%9A%E5%8A%A1%E6%9C%8D%E5%8A%A1%20--%3E%20%E5%AE%A2%E6%88%B7%E4%BA%A7%E5%93%81%3A%20%E8%BF%94%E5%9B%9ERoomToken%E5%92%8Cuuid%0A%0A%E5%AE%A2%E6%88%B7%E4%BA%A7%E5%93%81%20-%3E%20WhiteSDK%3A%20%E5%BB%BA%E7%AB%8B%E8%BF%9E%E6%8E%A5%EF%BC%88joinRoom%EF%BC%89%0A%0AWhiteSDK%20-%3E%20White%E4%BA%91%3A%20%E5%BB%BA%E7%AB%8B%E8%BF%9E%E6%8E%A5%0A%0A%40enduml"><img src="https://cdn.nlark.com/__puml/c2e1819cdafcd7c0fa9130187da08aee.svg" width="656"/></div>


## 结合 RTC 服务
RTC 供应商一般也会有房间（room）或频道（channel）的概念。White 的一块白板内部称之为 room，room 的 uuid 属性全局唯一，用户可以把 RTC 的房间或频道和 White 的 room 一一对应起来。
