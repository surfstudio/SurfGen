# ServiceGenerationStage

``` swift
public struct ServiceGenerationStage: PipelineEntryPoint
```

## Inheritance

[`PipelineEntryPoint`](/PipelineEntryPoint)

## Initializers

### `init(templatePathes:)`

``` swift
public init(templatePathes: [String])
```

## Properties

### `templatePathes`

``` swift
var templatePathes: [String]
```

## Methods

### `run(with:)`

``` swift
public func run(with input: [[ServiceModel]]) throws
```
