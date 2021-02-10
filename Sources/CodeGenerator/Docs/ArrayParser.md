# ArrayParser

``` swift
public protocol ArrayParser
```

## Requirements

### parse(schema:​current:​other:​)

``` swift
func parse(schema: SchemaObjectNode, current: DependencyWithTree, other: [DependencyWithTree]) throws -> SchemaArrayModel.PossibleType
```

### parse(array:​current:​other:​)

``` swift
func parse(array: SchemaArrayNode, current: DependencyWithTree, other: [DependencyWithTree]) throws -> SchemaArrayModel
```
