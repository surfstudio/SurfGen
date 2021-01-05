# AnyServiceBuilder

Default implementation for `ServiceBuilder`
Builds `path` elements of Open-API spec

``` swift
public struct AnyServiceBuilder: ServiceBuilder
```

**WARNING**

This struct cuts out response bodies without content. So if response doesn't have body then it will be just `nil`

  - See: https://swagger.io/docs/specification/paths-and-operations/

> 

> 

## Inheritance

[`ServiceBuilder`](./ServiceBuilder)

## Initializers

### `init(parameterBuilder:schemaBuilder:requestBodyBuilder:responseBuilder:)`

``` swift
public init(parameterBuilder: ParametersBuilder, schemaBuilder: SchemaBuilder, requestBodyBuilder: RequestBodyBuilder, responseBuilder: ResponseBuilder)
```

## Methods

### `build(paths:)`

Build all item which are under `paths:​`

``` swift
public func build(paths: [Path]) throws -> [PathNode]
```
