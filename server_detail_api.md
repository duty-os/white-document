<span data-type="color" style="color:rgb(51, 51, 51)"><span data-type="background" style="background-color:rgb(255, 255, 255)">REST API 可以让你用任何支持发送 HTTP 请求的设备来与 White 进行交互。</span></span>

## API 请求域名
```plain
https://cloudcapiv3.herewhite.com
```

## API 版本

| 版本 | 内容 |
| :--- | :--- |
| 1.0 | 公测版本 |

## 白板管理

<div class="bi-table">
  <table>
    <colgroup>
      <col width="291px" />
      <col width="112px" />
      <col width="177px" />
      <col width="168px" />
    </colgroup>
    <tbody>
      <tr height="34px">
        <td rowspan="1" colSpan="1">
          <div data-type="p">URL</div>
        </td>
        <td rowspan="1" colSpan="1">
          <div data-type="p">HTTP Method</div>
        </td>
        <td rowspan="1" colSpan="1">
          <div data-type="p">HTTP Body</div>
        </td>
        <td rowspan="1" colSpan="1">
          <div data-type="p">功能</div>
        </td>
      </tr>
      <tr height="34px">
        <td rowspan="1" colSpan="1">
          <div data-type="p">/room?token=token</div>
        </td>
        <td rowspan="1" colSpan="1">
          <div data-type="p">POST</div>
        </td>
        <td rowspan="1" colSpan="1">
          <div data-type="p">{</div>
          <div data-type="p"> &quot;name&quot;:&quot;111&quot;,</div>
          <div data-type="p"> &quot;limit&quot;:100</div>
          <div data-type="p">}</div>
        </td>
        <td rowspan="1" colSpan="1">
          <div data-type="p">创建白板：</div>
          <ul data-type="unordered-list">
            <li data-type="list-item" data-list-type="unordered-list">
              <div data-type="p">Body 中的 name 用于指定白板的名称，limit 用于限制白板人数（目前软限制）</div>
            </li>
          </ul>
        </td>
      </tr>
      <tr height="34px">
        <td rowspan="1" colSpan="1">
          <div data-type="p">/room?offset=0&amp;limit=100&amp;token=token</div>
        </td>
        <td rowspan="1" colSpan="1">
          <div data-type="p">GET</div>
        </td>
        <td rowspan="1" colSpan="1">
          <div data-type="p"></div>
        </td>
        <td rowspan="1" colSpan="1">
          <div data-type="p">获取白板列表：</div>
          <ul data-type="unordered-list">
            <li data-type="list-item" data-list-type="unordered-list">
              <div data-type="p">URL 中的 offset 指从第几块白板开始查找，从 0 开始，limit 指获取多少块白板的信息，用于翻页功能。</div>
            </li>
          </ul>
        </td>
      </tr>
      <tr height="34px">
        <td rowspan="1" colSpan="1">
          <div data-type="p">/room/id?uuid=uuid&amp;token=token</div>
        </td>
        <td rowspan="1" colSpan="1">
          <div data-type="p">GET</div>
        </td>
        <td rowspan="1" colSpan="1">
          <div data-type="p"></div>
        </td>
        <td rowspan="1" colSpan="1">
          <div data-type="p">获取某个白板信息：</div>
          <ul data-type="unordered-list">
            <li data-type="list-item" data-list-type="unordered-list">
              <div data-type="p">URL 中的 uuid 指要获取白板的 uuid ，用于全局确定一块白板</div>
            </li>
          </ul>
        </td>
      </tr>
      <tr height="34px">
        <td rowspan="1" colSpan="1">
          <div data-type="p">/room/join?uuid=uuid&amp;token=token</div>
        </td>
        <td rowspan="1" colSpan="1">
          <div data-type="p">POST</div>
        </td>
        <td rowspan="1" colSpan="1">
          <div data-type="p"></div>
        </td>
        <td rowspan="1" colSpan="1">
          <div data-type="p">参与指定白板：</div>
          <ul data-type="unordered-list">
            <li data-type="list-item" data-list-type="unordered-list">
              <div data-type="p">URL 中的 uuid 指要获取白板的 uuid ，用于全局确定一块白板</div>
            </li>
          </ul>
        </td>
      </tr>
      <tr height="34px">
        <td rowspan="1" colSpan="1">
          <div data-type="p">/room/close?token=token</div>
        </td>
        <td rowspan="1" colSpan="1">
          <div data-type="p">DELETE</div>
        </td>
        <td rowspan="1" colSpan="1">
          <div data-type="p">{</div>
          <div data-type="p"> &quot;uuid&quot;:uuid</div>
          <div data-type="p">}</div>
        </td>
        <td rowspan="1" colSpan="1">
          <div data-type="p">删除白板：</div>
          <ul data-type="unordered-list">
            <li data-type="list-item" data-list-type="unordered-list">
              <div data-type="p">Body 中的 uuid 指要获取白板的 uuid ，用于全局确定一块白板</div>
            </li>
          </ul>
        </td>
      </tr>
    </tbody>
  </table>
</div>

### 请求格式
<span data-type="color" style="color:rgb(51, 51, 51)"><span data-type="background" style="background-color:rgb(255, 255, 255)">对于 POST 和 PUT 请求，请求的主体必须是 JSON 格式，而且 HTTP header 的 Content-Type 需要设置为 </span></span>`application/json`

<span data-type="color" style="color:rgb(51, 51, 51)"><span data-type="background" style="background-color:rgb(255, 255, 255)">用户验证通过通过 URL 参数中的 token 进行验证，token 来源参考：</span></span>[快速开始](./js_quickstart.md)

### 响应格式
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

## 业务服务器和 White 的关系
<div id="eiwrfi" data-type="puml" data-display="block" data-align="left" data-src="https://cdn.nlark.com/__puml/c2e1819cdafcd7c0fa9130187da08aee.svg" data-width="656" data-height="300" data-text="%40startuml%0A%0Aautonumber%0A%0A%E5%AE%A2%E6%88%B7%E4%BA%A7%E5%93%81%20-%3E%20%E5%AE%A2%E6%88%B7%E4%B8%9A%E5%8A%A1%E6%9C%8D%E5%8A%A1%3A%20%E5%88%9B%E5%BB%BA%E7%99%BD%E6%9D%BF%0A%0A%E5%AE%A2%E6%88%B7%E4%B8%9A%E5%8A%A1%E6%9C%8D%E5%8A%A1%20-%3E%20White%E4%BA%91%3A%20%E5%88%9B%E5%BB%BA%E7%99%BD%E6%9D%BF%EF%BC%88createRoom%EF%BC%89%0A%0AWhite%E4%BA%91%20--%3E%20%E5%AE%A2%E6%88%B7%E4%B8%9A%E5%8A%A1%E6%9C%8D%E5%8A%A1%3A%20%E8%BF%94%E5%9B%9ERoomToken%E5%92%8Cuuid%0A%0A%E5%AE%A2%E6%88%B7%E4%B8%9A%E5%8A%A1%E6%9C%8D%E5%8A%A1%20-%3E%20%E5%AE%A2%E6%88%B7%E4%B8%9A%E5%8A%A1%E6%95%B0%E6%8D%AE%E5%BA%93%3A%20%E8%AE%B0%E5%BD%95%E7%99%BD%E6%9D%BFuuid%0A%0A%E5%AE%A2%E6%88%B7%E4%B8%9A%E5%8A%A1%E6%9C%8D%E5%8A%A1%20--%3E%20%E5%AE%A2%E6%88%B7%E4%BA%A7%E5%93%81%3A%20%E8%BF%94%E5%9B%9ERoomToken%E5%92%8Cuuid%0A%0A%E5%AE%A2%E6%88%B7%E4%BA%A7%E5%93%81%20-%3E%20WhiteSDK%3A%20%E5%BB%BA%E7%AB%8B%E8%BF%9E%E6%8E%A5%EF%BC%88joinRoom%EF%BC%89%0A%0AWhiteSDK%20-%3E%20White%E4%BA%91%3A%20%E5%BB%BA%E7%AB%8B%E8%BF%9E%E6%8E%A5%0A%0A%40enduml"><img src="https://cdn.nlark.com/__puml/c2e1819cdafcd7c0fa9130187da08aee.svg" width="656"/></div>


## 结合 RTC 服务
RTC 供应商一般也会有房间（room）或频道（channel）的概念。White 的一块白板内部称之为 room，room 的 uuid 属性全局唯一，用户可以把 RTC 的房间或频道和 White 的 room 一一对应起来。

## Postman 配置文件
如你也像我们一样使用 Postman 调试 API，恭喜这里有份 Postman 文件。可以导入（import）进你的 Postman 来协作调试。
[download: White Open API.postman_collection.json](https://www.yuque.com/attachments/yuque/0/2018/json/102615/1534413105738-be02202c-dae7-451a-af5d-e195a7a59139.json "size:3760")
*请替换其中的 token 为注册后得到的 token。*
