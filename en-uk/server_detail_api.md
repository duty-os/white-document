# Server API

The REST API lets you interact with White with any device that supports sending HTTP requests.

## API request domain name

```plain
https://cloudcapiv3.herewhite.com
```

## API version

| version | content |
| :--- | :--- |
| 1.0 | Public beta version |

## Whiteboard management

<div class="bi-table">
  <table>
    <colgroup>
      <col width="291px" />
      <col width="112px" />
      <col width="120px" />
      <col width="280px" />
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
          <div data-type="p">Features</div>
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
          <div data-type="p">Create a whiteboard:</div>
          <ul data-type="unordered-list">
            <li data-type="list-item" data-list-type="unordered-list">
              <div data-type="p">The name in the Body is used to specify the name of the whiteboard, and the limit is used to limit the number of whiteboards (current soft limit)</div>
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
          <div data-type="p">Get a list of whiteboards:</div>
          <ul data-type="unordered-list">
            <li data-type="list-item" data-list-type="unordered-list">
              <div data-type="p">The offset in the URL refers to the search from the first whiteboard, starting from 0, and the limit refers to how many whiteboards are acquired for page turning.</div>
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
          <div data-type="p">Get a whiteboard information:</div>
          <ul data-type="unordered-list">
            <li data-type="list-item" data-list-type="unordered-list">
              <div data-type="p">Uuid in the URL refers to the uuid of the whiteboard to be used to determine a whiteboard globally.</div>
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
          <div data-type="p">Participate in the designated whiteboard:</div>
          <ul data-type="unordered-list">
            <li data-type="list-item" data-list-type="unordered-list">
              <div data-type="p">Uuid in the URL refers to the uuid of the whiteboard to be used to determine a whiteboard globally.</div>
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
          <div data-type="p">Delete the whiteboard:</div>
          <ul data-type="unordered-list">
            <li data-type="list-item" data-list-type="unordered-list">
              <div data-type="p">Uuid in the body refers to the uuid of the whiteboard to be used to determine a whiteboard globally.</div>
            </li>
          </ul>
        </td>
      </tr>
    </tbody>
  </table>
</div>

### Request format

For POST and PUT requests, the body of the request must be in JSON format, and the Content-Type of the HTTP header needs to be set to `application/json`.

User authentication is verified by passing tokens in the URL parameter, token source reference: [https://www.yuque.com/herewhite/sdk/quickstart#f3nvan](https://www.yuque.com/herewhite/sdk/quickstart#f3nvan)

### Response format

The response format is a JSON object for all requests.

A request always contains a code field, 200 for success, and a successful response with a msg field indicating the return of a specific business:

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

When a request fails, the body of the response is still a JSON object, but always contains the fields `code` and `msg`, which you can use for debugging, for example:

```json
{
  "code": 112,
  "msg": "require uuid"
}
```

## Business server and White relationship

<div id="eiwrfi" data-type="puml" data-display="block" data-align="left" data-src="https://cdn.nlark.com/__puml/c2e1819cdafcd7c0fa9130187da08aee.svg" data-width="656" data-height="300" data-text="%40startuml%0A%0Aautonumber%0A%0A%E5%AE%A2%E6%88%B7%E4%BA%A7%E5%93%81%20-%3E%20%E5%AE%A2%E6%88%B7%E4%B8%9A%E5%8A%A1%E6%9C%8D%E5%8A%A1%3A%20%E5%88%9B%E5%BB%BA%E7%99%BD%E6%9D%BF%0A%0A%E5%AE%A2%E6%88%B7%E4%B8%9A%E5%8A%A1%E6%9C%8D%E5%8A%A1%20-%3E%20White%E4%BA%91%3A%20%E5%88%9B%E5%BB%BA%E7%99%BD%E6%9D%BF%EF%BC%88createRoom%EF%BC%89%0A%0AWhite%E4%BA%91%20--%3E%20%E5%AE%A2%E6%88%B7%E4%B8%9A%E5%8A%A1%E6%9C%8D%E5%8A%A1%3A%20%E8%BF%94%E5%9B%9ERoomToken%E5%92%8Cuuid%0A%0A%E5%AE%A2%E6%88%B7%E4%B8%9A%E5%8A%A1%E6%9C%8D%E5%8A%A1%20-%3E%20%E5%AE%A2%E6%88%B7%E4%B8%9A%E5%8A%A1%E6%95%B0%E6%8D%AE%E5%BA%93%3A%20%E8%AE%B0%E5%BD%95%E7%99%BD%E6%9D%BFuuid%0A%0A%E5%AE%A2%E6%88%B7%E4%B8%9A%E5%8A%A1%E6%9C%8D%E5%8A%A1%20--%3E%20%E5%AE%A2%E6%88%B7%E4%BA%A7%E5%93%81%3A%20%E8%BF%94%E5%9B%9ERoomToken%E5%92%8Cuuid%0A%0A%E5%AE%A2%E6%88%B7%E4%BA%A7%E5%93%81%20-%3E%20WhiteSDK%3A%20%E5%BB%BA%E7%AB%8B%E8%BF%9E%E6%8E%A5%EF%BC%88joinRoom%EF%BC%89%0A%0AWhiteSDK%20-%3E%20White%E4%BA%91%3A%20%E5%BB%BA%E7%AB%8B%E8%BF%9E%E6%8E%A5%0A%0A%40enduml"><img src="https://cdn.nlark.com/__puml/c2e1819cdafcd7c0fa9130187da08aee.svg" width="656"/></div>


## Combine RTC services

RTC vendors also generally have the concept of a room or a channel. One of White's whiteboards is called room, and the uuid attribute of the room is globally unique. Users can match the RTC room or channel to the White room one by one.

## Postman configuration file

If you also use the Postman Debugging API like us, congratulations to the Postman file. You can import it into your Postman to collaborate and debug.
[download: White Open API.postman_collection.json](https://www.yuque.com/attachments/yuque/0/2018/json/102615/1534413105738-be02202c-dae7-451a-af5d-e195a7a59139.json "size:3760")
*Please replace the token with the token obtained after registration.*
