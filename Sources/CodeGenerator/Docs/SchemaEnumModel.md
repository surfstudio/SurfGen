# SchemaEnumModel

Describes enum declration with cases.

``` swift
public struct SchemaEnumModel: Encodable
```

``` YAML

components:
    schemas:
        MyEnum:
            type: string
            enum: ['one', 'two', 'tree', 'and more']
```

Can be only primitive.

*and please, don't create bool enums* (:

## Serialization schema

``` YAML
SchemaEnumModel:
    type: object
    prperties:
        name:
            type: string
        cases:
            type: array
            items:
                type: string
        type:
            description: Property's type
            type:
                $ref: "primitive_type.yaml#/components/schemas/PrimitiveType"
```

## Inheritance

`Encodable`

## Properties

### `name`

``` swift
let name: String
```

### `cases`

``` swift
let cases: [String]
```

### `type`

``` swift
let type: PrimitiveType
```
