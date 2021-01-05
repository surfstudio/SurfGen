# SchemaType

This is the enumeration of possible schema object

``` swift
public indirect enum SchemaType
```

It's about entities that is written in `schemas:` part
In terms of this comments any items which is encluded in `schemas:` part is called `entity`

## Serialization schema

``` YAML

Type:
    type: string
    enum: ['alias', 'enum', 'object', 'array', 'group']

SchemaType:
    type: object
    prperties:
        name:
            type: string
        type:
            type:
                $ref: "#/components/schemas/Type"
        value:
            type:
                oneOf:
                    - $ref: "primitive_type_alias_model.yaml#/components/schemas/PrimitiveTypeAliasModel"
                    - $ref: "schema_enum_model.yaml#/components/schemas/SchemaEnumModel"
                    - $ref: "schema_object_model.yaml#/components/schemas/SchemaObjectModel"
                    - $ref: "schema_array_model.yaml#/components/schemas/SchemaArrayModel"
                    - $ref: "schema_group_model.yaml#/components/schemas/SchemaGroupModel"
```

## Inheritance

`Encodable`

## Enumeration Cases

### `alias`

Just a primitive type
Schema which is primitive is just an alias

``` swift
case alias(: PrimitiveTypeAliasModel)
```

For example:

``` YAML
schemas:
    UserID:
        type: string
```

And `UserID` is just an alias on `String` type

In Swift it would look like `typealias UserID = String`

### `` `enum` ``

It's an entity with `PrimitiveType` but it has property `enum`

``` swift
case `enum`(: SchemaEnumModel)
```

### `object`

Entity whose `type` property is `object`

``` swift
case object(: SchemaObjectModel)
```

### `array`

Entity whose type is `array`

``` swift
case array(: SchemaArrayModel)
```

### `group`

It's about:​

``` swift
case group(: SchemaGroupModel)
```

``` YAML
schemas:
 GroupExample:
     oneOf | allOf | anyOf:
         - $ref: ".."
         - $ref: ".."
         ....
```

## Methods

### `encode(to:)`

``` swift
public func encode(to encoder: Encoder) throws
```
