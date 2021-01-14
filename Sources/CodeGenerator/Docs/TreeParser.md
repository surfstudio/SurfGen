# TreeParser

``` swift
public struct TreeParser
```

## Initializers

### `init(parametersParser:requestBodyParser:responsesParser:)`

``` swift
public init(parametersParser: ParametersTreeParser, requestBodyParser: RequestBodyParser, responsesParser: ResponseBodyParser)
```

## Methods

### `parse(trees:)`

``` swift
public func parse(trees: [DependencyWithTree]) throws -> [[ServiceModel]]
```
