# ResponseBodyParser

``` swift
public struct ResponseBodyParser
```

## Initializers

### `init(mediaTypeParser:)`

``` swift
public init(mediaTypeParser: MediaTypeParser)
```

## Properties

### `mediaTypeParser`

``` swift
let mediaTypeParser: MediaTypeParser
```

## Methods

### `parse(responses:current:other:)`

``` swift
public func parse(responses: [OperationNode.ResponseBody], current: DependencyWithTree, other: [DependencyWithTree]) throws -> [Reference<ResponseModel>]
```
