# RootNode

``` swift
public struct RootNode
```

## Initializers

### `init(schemas:parameters:services:requestBodies:responses:)`

``` swift
public init(schemas: [SchemaObjectNode], parameters: [ParameterNode], services: [PathNode], requestBodies: [ComponentRequestBodyNode], responses: [ComponentResponseNode])
```

## Properties

### `schemas`

``` swift
var schemas: [SchemaObjectNode]
```

### `parameters`

``` swift
var parameters: [ParameterNode]
```

### `requestBodies`

``` swift
var requestBodies: [ComponentRequestBodyNode]
```

### `responses`

``` swift
var responses: [ComponentResponseNode]
```

### `services`

``` swift
var services: [PathNode]
```

## Methods

### `resolve(reference:)`

Awaits `#/components/schemas|parameters|responses|requestBodies/ModelName`

``` swift
public func resolve<T>(reference: String) throws -> T
```
