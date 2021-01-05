# AnyResponsesBuilder

Default implementation of both `ResponseBuilder` and `ResponsesBuilder`

``` swift
public struct AnyResponsesBuilder: ResponsesBuilder, ResponseBuilder
```

  - See: https://swagger.io/docs/specification/describing-responses/

## Don't support

### Response body without content. They are mapped to `nil`

## Inheritance

[`ResponseBuilder`](./Docs/ResponseBuilder), [`ResponsesBuilder`](./Docs/ResponsesBuilder)

## Initializers

### `init(mediaTypesBuilder:)`

``` swift
public init(mediaTypesBuilder: MediaTypesBuilder)
```

## Properties

### `mediaTypesBuilder`

``` swift
let mediaTypesBuilder: MediaTypesBuilder
```

## Methods

### `build(responses:)`

``` swift
public func build(responses: [ComponentObject<Response>]) throws -> [ComponentResponseNode]
```

### `build(response:)`

``` swift
public func build(response: Response) throws -> ResponseNode
```
