# AnyMediaTypeParser

``` swift
public struct AnyMediaTypeParser: MediaTypeParser
```

## Inheritance

[`MediaTypeParser`](/MediaTypeParser)

## Initializers

### `init(arrayParser:groupParser:)`

``` swift
public init(arrayParser: ArrayParser, groupParser: AnyGroupParser)
```

## Properties

### `arrayParser`

``` swift
let arrayParser: ArrayParser
```

### `groupParser`

``` swift
let groupParser: AnyGroupParser
```

## Methods

### `parse(mediaType:current:other:)`

``` swift
public func parse(mediaType: MediaTypeObjectNode, current: DependencyWithTree, other: [DependencyWithTree]) throws -> DataModel
```

### `parse(schema:current:other:)`

``` swift
public func parse(schema: SchemaObjectNode, current: DependencyWithTree, other: [DependencyWithTree]) throws -> DataModel.PossibleType
```
