# OperationNode.ResponseBody

``` swift
public struct ResponseBody
```

## Initializers

### `init(key:response:)`

``` swift
public init(key: String, response: Referenced<ResponseNode>?)
```

## Properties

### `key`

May be `200` or `default` etc.
Fo more imformation look at https:​//swagger.io/specification/\#responses-object

``` swift
let key: String
```

### `response`

``` swift
let response: Referenced<ResponseNode>?
```
