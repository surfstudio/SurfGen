# OperationNode

``` swift
public struct OperationNode
```

## Initializers

### `init(method:description:summary:parameters:requestBody:responses:)`

``` swift
public init(method: String, description: String?, summary: String?, parameters: [Referenced<ParameterNode>], requestBody: Referenced<RequestBodyNode>?, responses: [ResponseBody])
```

## Properties

### `method`

``` swift
let method: String
```

### `description`

``` swift
let description: String?
```

### `summary`

``` swift
let summary: String?
```

### `parameters`

``` swift
let parameters: [Referenced<ParameterNode>]
```

### `requestBody`

``` swift
let requestBody: Referenced<RequestBodyNode>?
```

### `responses`

``` swift
let responses: [ResponseBody]
```
