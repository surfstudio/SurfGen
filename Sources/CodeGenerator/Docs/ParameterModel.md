# ParameterModel

Method's URI parameter

``` swift
public struct ParameterModel: Encodable
```

For example URI `https://ex.com/projects/{projectId}/user?name={userName}`

contains 2 parameters:

  - projectId - `Path parameter`

  - userName - `Query parameter`

Of course parameters have type.

And it may be one of:

  - `PrimitiveType` - `primitive`

  - `SchemaType` - `reference`

  - `SchemaArrayModel` - `array`

## Serialization schema

``` YAML
Type:
    type: string
    enum: ['primitive', 'reference', 'array']

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
                        - $ref: "primitive_type.yaml#/component/schemas/PrimitiveType"
                        - $ref: "schema_type.yaml#/component/schemas/SchemaType"
                        - $ref: "schema_array_model.yaml#/component/schemas/SchemaArrayModel"

ParameterModel:
    type: object
    properties:
        componentName:
            type: string
            nullable: true
        name:
            type: string
        location:
            type:
                $ref: "#/components/schemas/Location"
        type:
            type:
                $ref: "#/components/schemas/PossibleType"
        description:
            type: string
            nullable: true
        isRequired:
            type: boolean
```

## Inheritance

`Encodable`

## Properties

### `componentName`

Parameter can be declared both inside operation
and separately of method definition.

``` swift
let componentName: String?
```

So if parameter was declared separately this field will set
For `OpenAPI` it's component name

For example:

``` YAML
components:
    parameters:
        MyParamComponentName:
            name: projectId
            in: path
            shema:
                type: integer
```

For this case `componentName` will be set to `MyParamComponentName`

### `name`

Parametr name (as name in URI)

``` swift
let name: String
```

For `projectId` it will be `projectId`

### `location`

Place where parameter must be set

``` swift
let location: ParameterNode.Location
```

### `type`

``` swift
let type: PossibleType
```

### `description`

``` swift
let description: String?
```

### `isRequired`

``` swift
let isRequired: Bool
```
