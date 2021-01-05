# AnyRequestBodiesBuilder

Default implementation for both `RequestBodyBuilder` and `RequestBodiesBuilder`

``` swift
public struct AnyRequestBodiesBuilder: RequestBodiesBuilder, RequestBodyBuilder
```

  - See: https://swagger.io/docs/specification/describing-request-body/

*seems lke that it's the only one implementation which isn't contain some restrictions :D*

## Inheritance

[`RequestBodyBuilder`](./Docs/RequestBodyBuilder), [`RequestBodiesBuilder`](./Docs/RequestBodiesBuilder)

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

### `build(requestBodies:)`

``` swift
public func build(requestBodies: [ComponentObject<RequestBody>]) throws -> [ComponentRequestBodyNode]
```

### `build(requestBody:)`

``` swift
public func build(requestBody: RequestBody) throws -> RequestBodyNode
```
