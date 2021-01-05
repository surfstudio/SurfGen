# BuildGASTTreeEntryPoint

``` swift
public struct BuildGASTTreeEntryPoint
```

## Inheritance

[`PipelineEntryPoint`](/PipelineEntryPoint)

## Nested Type Aliases

### `ReferenceExtractorProvider`

``` swift
public typealias ReferenceExtractorProvider = (URL) throws -> ReferenceExtractor
```

## Initializers

### `init(refExtractorProvider:next:)`

``` swift
public init(refExtractorProvider: @escaping ReferenceExtractorProvider, next: BuildGastTreeParseDependenciesSatage)
```

## Methods

### `run(with:)`

``` swift
public func run(with input: Config) throws
```
