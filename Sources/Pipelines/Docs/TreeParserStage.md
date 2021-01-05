# TreeParserStage

``` swift
public struct TreeParserStage: PipelineEntryPoint
```

## Inheritance

[`PipelineEntryPoint`](/PipelineEntryPoint)

## Initializers

### `init(next:parser:)`

``` swift
public init(next: AnyPipelineEntryPoint<[[ServiceModel]]>, parser: TreeParser)
```

## Properties

### `parser`

``` swift
let parser: TreeParser
```

## Methods

### `run(with:)`

``` swift
public func run(with input: [DependencyWithTree]) throws
```
