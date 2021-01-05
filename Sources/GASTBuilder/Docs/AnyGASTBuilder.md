# AnyGASTBuilder

Parse `API specification` to `OpenAPI-AST` then build the `GAST` from it.

``` swift
public struct AnyGASTBuilder: GASTBuilder
```

It's a composition of different builders
This object just read file, build OpenAPI-AST with help of `Swagger` lib
And then run different builders for different spec's components to make `GAST`

> 

## Inheritance

[`GASTBuilder`](./GASTBuilder)

## Initializers

### `init(fileProvider:schemaBuilder:parameterBuilder:serviceBuilder:responsesBuilder:requestBodiesBuilder:)`

``` swift
public init(fileProvider: FileProvider, schemaBuilder: SchemaBuilder, parameterBuilder: ParametersBuilder, serviceBuilder: ServiceBuilder, responsesBuilder: ResponsesBuilder, requestBodiesBuilder: RequestBodiesBuilder)
```

## Methods

### `build(filePath:)`

Create GAST from spec file

``` swift
public func build(filePath: String) throws -> RootNode
```
