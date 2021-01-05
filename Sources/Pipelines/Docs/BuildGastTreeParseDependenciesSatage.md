# BuildGastTreeParseDependenciesSatage

``` swift
public struct BuildGastTreeParseDependenciesSatage: PipelineEntryPoint
```

## Inheritance

[`PipelineEntryPoint`](./PipelineEntryPoint)

## Initializers

### `init(builder:next:)`

``` swift
public init(builder: GASTBuilder, next: AnyPipelineEntryPoint<[DependencyWithTree]>)
```

## Methods

### `run(with:)`

``` swift
public func run(with input: [Dependency]) throws
```
