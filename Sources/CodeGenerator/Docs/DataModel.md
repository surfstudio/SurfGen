# DataModel

Data which is used in `RequestModel` and `ResponseModel`

``` swift
public struct DataModel: Encodable
```

Can be:

  - `SchemaObjectModel` or `object`

  - `SchemaArrayModel` or `array`

  - `SchemaGroupModel` or `group`

## Serialization schema

``` YAML
Type:
    type: string
    enum: ['object', 'array', 'group']

Location:
    type: string
    enum: ['query', 'path']

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
                        - $ref: "schema_object_model.yaml#/component/schemas/SchemaObjectModel"
                        - $ref: "schema_array_model.yaml#/component/schemas/SchemaArrayModel"
                        - $ref: "schema_group_model.yaml#/component/schemas/SchemaGroupModel"

DataModel:
    type: object
    properties:
        mediaType:
            type: string
        type:
            type:
                $ref: "#/components/schemas/PossibleType"
```

## Inheritance

`Encodable`

## Initializers

### `init(mediaType:type:)`

``` swift
public init(mediaType: String, type: PossibleType)
```

## Properties

### `mediaType`

Media-Type value

``` swift
let mediaType: String
```

For example:

``` 
application/json
```

### `type`

``` swift
let type: PossibleType
```
