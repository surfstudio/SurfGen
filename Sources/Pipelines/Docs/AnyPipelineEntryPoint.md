# AnyPipelineEntryPoint

Just a Box for any specific type of PipelineEntryPoint

``` swift
public struct AnyPipelineEntryPoint<Input>: PipelineEntryPoint
```

## Inheritance

[`PipelineEntryPoint`](./PipelineEntryPoint)

## Initializers

### `init(nested:)`

``` swift
public init<Nested: PipelineEntryPoint>(nested: Nested) where Nested.Input == Input
```

## Methods

### `run(with:)`

``` swift
public func run(with input: Input) throws
```
