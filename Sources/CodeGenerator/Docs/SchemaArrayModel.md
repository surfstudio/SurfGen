# SchemaArrayModel

Describes array

``` swift
public struct SchemaArrayModel: Encodable
```

``` YAML
    BasketItem:
       type: object
       properties:
         itemIds:
           type: array      # <-- That's our SchemaArrayModel
           items:
             type: integer
```

## Serialization schema

``` YAML

Type:
    type: string
    enum: ['primitive', 'reference']

PossibleType:
    type: object
    properties:
        type:
            description: String description of vaue's type
            type:
                $ref: "#/components/schemas/Type"
        value:
            type:
                schema:
                    oneOf:
                        - $ref: "primitive_type.yaml#/component/schemas/PrimitiveType"
                        - $ref: "schema_type.yaml#/component/schemas/SchemaType"      # <-- `Type.reference`

SchemaArrayModel:
    type: object
    prperties:
        name:
            type: string
        itemsType:
            description: Property's type
            type:
                $ref: "#/components/schemas/PossibleType"
```

## Inheritance

`Encodable`

## Initializers

### `init(name:itemsType:)`

``` swift
public init(name: String, itemsType: PossibleType)
```

## Properties

### `name`

For arrays decalred in-lace this field will be empty

``` swift
var name: String
```

### `itemsType`

``` swift
var itemsType: PossibleType
```
