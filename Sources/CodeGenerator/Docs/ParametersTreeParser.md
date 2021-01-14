# ParametersTreeParser

``` swift
public struct ParametersTreeParser
```

## Initializers

### `init(array:)`

``` swift
public init(array: ArrayParser)
```

## Properties

### `array`

``` swift
let array: ArrayParser
```

## Methods

### `parse(parameter:current:other:)`

``` swift
public func parse(parameter: Referenced<ParameterNode>, current: DependencyWithTree, other: [DependencyWithTree]) throws -> Reference<ParameterModel>
```
