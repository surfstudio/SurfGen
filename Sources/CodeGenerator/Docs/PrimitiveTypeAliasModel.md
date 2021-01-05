# PrimitiveTypeAliasModel

Describes alias. Or named primitive type

``` swift
public struct PrimitiveTypeAliasModel: Encodable
```

For example:

``` YAML
components:
    schemas:
        UserID:
            type: string
```

Can only be `primitive`

## Serialization schema

``` YAML
PrimitiveTypeAliasModel:
    type: object
    properties:
        name:
            type: string
        type:
            $ref: "primitive_type.yaml#/components/schemas/PrimitiveType"
```

## Inheritance

`Encodable`

## Initializers

### `init(name:type:)`

``` swift
public init(name: String, type: PrimitiveType)
```

## Properties

### `name`

Component's name.
For example above it will be `userID`

``` swift
let name: String
```

### `type`

``` swift
let type: PrimitiveType
```
