# InitCodeGenerationStage

``` swift
public struct InitCodeGenerationStage: PipelineEntryPoint
```

## Inheritance

[`PipelineEntryPoint`](./PipelineEntryPoint)

## Initializers

### `init(parserStage:)`

``` swift
public init(parserStage: TreeParserStage)
```

## Properties

### `next`

``` swift
var next: TreeParserStage
```

## Methods

### `run(with:)`

``` swift
public func run(with input: [DependencyWithTree]) throws
```
