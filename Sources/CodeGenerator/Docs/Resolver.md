# Resolver

This class can resolve references
It can resolve local references and references to another files
It can determine referece cycles and throw error with call stack

``` swift
public class Resolver
```

**WARNING**
**ISN'T THREAD SAFE**

## Initializers

### `init()`

``` swift
public init()
```

## Methods

### `resolveParameter(ref:node:other:)`

``` swift
public func resolveParameter(ref: String, node: DependencyWithTree, other: [DependencyWithTree]) throws -> ParameterModel
```

### `resolveSchema(ref:node:other:)`

``` swift
public func resolveSchema(ref: String, node: DependencyWithTree, other: [DependencyWithTree]) throws -> SchemaType
```

### `resolveRefToAnotherFile(ref:node:other:)`

``` swift
public func resolveRefToAnotherFile(ref: String, node: DependencyWithTree, other: [DependencyWithTree]) throws -> DependencyWithTree
```
