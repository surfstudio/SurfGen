# RequestBodyParser

``` swift
public struct RequestBodyParser
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

### `parse(requestBody:current:other:)`

``` swift
public func parse(requestBody: Referenced<RequestBodyNode>, current: DependencyWithTree, other: [DependencyWithTree]) throws -> Reference<RequestModel>
```
