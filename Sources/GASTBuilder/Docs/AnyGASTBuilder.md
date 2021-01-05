# AnyGASTBuilder

``` swift
public struct AnyGASTBuilder: GASTBuilder
```

## Inheritance

[`GASTBuilder`](/GASTBuilder)

## Initializers

### `init(fileProvider:schemaBuilder:parameterBuilder:serviceBuilder:responsesBuilder:requestBodiesBuilder:)`

``` swift
public init(fileProvider: FileProvider, schemaBuilder: SchemaBuilder, parameterBuilder: ParametersBuilder, serviceBuilder: ServiceBuilder, responsesBuilder: ResponsesBuilder, requestBodiesBuilder: RequestBodiesBuilder)
```

## Methods

### `build(filePath:)`

``` swift
public func build(filePath: String) throws -> RootNode
```
