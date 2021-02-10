# PropertyModel

Describes object's property

``` swift
public struct PropertyModel
```

``` YAML
components:
    schemas:
        MyObject:
            type: object
            properties:
                field:
                    type: integer
```

So this object represents `field`
May be one of:

  - `PrimitiveType` - `primitive`

  - `SchemaType` - `reference`

  - `array` which can be one of this enum (: (yah\! recursion\!)

## Serialization schema

``` YAML

Type:
    type: string
    enum: ['primitive', 'reference', 'array']

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
                        - $ref: "schema_type.yaml#/component/schemas/SchemaType"
                        - $ref: "schema_array_model.yaml#/component/schemas/SchemaArrayModel"

PropertyModel:
    type: object
    prperties:
        name:
            description: Propery name
            type: string
        description:
            description: Proprty's description form specification
            type: string
            nullable: true
        type:
            description: Property's type
            type:
                $ref: "#/components/schemas/PossibleType"
```

## Inheritance

`Encodable`

## Properties

### `name`

``` swift
let name: String
```

### `description`

``` swift
let description: String?
```

### `type`

``` swift
let type: PossibleType
```

## Methods

### `encode(to:)`

``` swift
public func encode(to encoder: Encoder) throws
```
