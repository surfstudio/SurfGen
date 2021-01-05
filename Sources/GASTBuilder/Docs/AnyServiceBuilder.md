# AnyServiceBuilder

``` swift
public struct AnyServiceBuilder: ServiceBuilder
```

## Inheritance

[`ServiceBuilder`](/ServiceBuilder)

## Initializers

### `init(parameterBuilder:schemaBuilder:requestBodyBuilder:responseBuilder:)`

``` swift
public init(parameterBuilder: ParametersBuilder, schemaBuilder: SchemaBuilder, requestBodyBuilder: RequestBodyBuilder, responseBuilder: ResponseBuilder)
```

## Methods

### `build(paths:)`

``` swift
public func build(paths: [Path]) throws -> [PathNode]
```
