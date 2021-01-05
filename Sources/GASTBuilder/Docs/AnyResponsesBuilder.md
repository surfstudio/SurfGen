# AnyResponsesBuilder

``` swift
public struct AnyResponsesBuilder: ResponsesBuilder, ResponseBuilder
```

## Inheritance

[`ResponseBuilder`](/ResponseBuilder), [`ResponsesBuilder`](/ResponsesBuilder)

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
