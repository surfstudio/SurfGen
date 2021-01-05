# SchemaGroupModel

Represents `oneOf`, `allOf` and `anyOf` keywords

``` swift
public struct SchemaGroupModel: Encodable
```

Can contains nested groups.

**WARNING**

This implementation can contains only references

*but, seriously, don't design your API like that*

``` YAML
components:
    schemas:
        MyGroup:
            oneOf:
                - $ref: "models.yaml#/components/schemas/AuthRequest"
                - $ref: "models.yaml#/components/schemas/SilentAuthRequest"
```

## Serialization schema

``` YAML

Type:
    type: string
    enum: ['object', 'group']

SchemaGroupType:
    type: string
    enum: ['oneOf', 'onyOf', 'allOf']

PossibleType:
    type: object
    properties:
        type:
            type:
                $ref: "#/components/schemas/Type"
        value:
            type:
                schema:
                    oneOf:
                        - $ref: "schema_object_model.yaml#/component/schemas/SchemaObjectModel"
                        - $ref: "schema_group_model.yaml#/component/schemas/SchemaGroupModel"

SchemaGroupModel:
    type: object
    prperties:
        name:
            type: string
        type:
            type:
                $ref: "#/components/schemas/SchemaGroupType"
        references:
            type: array
            items:
                $ref: "#/components/schemas/PossibleType"
```

## Inheritance

`Encodable`

## Initializers

### `init(name:references:type:)`

``` swift
public init(name: String, references: [PossibleType], type: SchemaGroupType)
```

## Properties

### `name`

``` swift
let name: String
```

### `references`

``` swift
let references: [PossibleType]
```

### `type`

``` swift
let type: SchemaGroupType
```
