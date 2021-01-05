# SchemaBuilder

Just an interface for any GAST-Schema builder

``` swift
public protocol SchemaBuilder
```

## Requirements

### build(schemas:​)

Build all item which are under `schemas:​`

``` swift
func build(schemas: [ComponentObject<Schema>]) throws -> [SchemaObjectNode]
```
