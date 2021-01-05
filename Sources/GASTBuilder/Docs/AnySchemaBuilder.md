# AnySchemaBuilder

Default implementation of `schema` builder.

``` swift
public struct AnySchemaBuilder: SchemaBuilder
```

``` YAML
components:
    schemas: # <-- Will build all items under this key
```

  - See: https://swagger.io/docs/specification/data-models/

> 

## Don't support

### Group type may be only reference.

For example it's **ok**

``` YAML
oneOf:
    - $ref: "..."
    - type: integer
```

but it's **not**

### Array may by only single-item

``` YAML
type: array
items:
    type: integer
```

**Not multiple**

``` YAML
type: array
items:
    type:
        - integer
        - string
```

### PrimitiveType can't be `any`

Isn't supported in any place

## Inheritance

[`SchemaBuilder`](./Docs/SchemaBuilder)

## Initializers

### `init()`

``` swift
public init()
```

## Methods

### `build(schemas:)`

Build all item which are under `schemas:​`

``` swift
public func build(schemas: [ComponentObject<Schema>]) throws -> [SchemaObjectNode]
```
