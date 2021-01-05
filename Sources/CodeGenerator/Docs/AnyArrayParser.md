# AnyArrayParser

``` swift
public struct AnyArrayParser: ArrayParser
```

## Inheritance

[`ArrayParser`](./Docs/ArrayParser)

## Initializers

### `init()`

``` swift
public init()
```

## Methods

### `parse(array:current:other:)`

``` swift
public func parse(array: SchemaArrayNode, current: DependencyWithTree, other: [DependencyWithTree]) throws -> SchemaArrayModel
```

### `parse(schema:current:other:)`

``` swift
public func parse(schema: SchemaObjectNode, current: DependencyWithTree, other: [DependencyWithTree]) throws -> SchemaArrayModel.PossibleType
```
