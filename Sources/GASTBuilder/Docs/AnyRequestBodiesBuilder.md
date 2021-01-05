# AnyRequestBodiesBuilder

``` swift
public struct AnyRequestBodiesBuilder: RequestBodiesBuilder, RequestBodyBuilder
```

## Inheritance

[`RequestBodyBuilder`](./RequestBodyBuilder), [`RequestBodiesBuilder`](./RequestBodiesBuilder)

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
