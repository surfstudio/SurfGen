# SchemaObjectModel

This data structure describes schema object.
In other words:​

``` swift
public struct SchemaObjectModel: Encodable
```

``` YAML
components:
     schemas:
         AnyObject: <-- `name`
             description: "description"  <-- `description`
             type: object # <-- this is important
             properties: <-- `properties`
                 field1:
                     type: string
```

## Serialization schema

``` YAML
SchemaObjectModel:
    type: object
    prperties:
        name:
            type: string
        description:
            type: string
            nullable: true
        properties:
            type: array
            items:
                $ref: "Property_model.yaml#/components/schemas/PropertyModel"
```

## Inheritance

`Encodable`

## Initializers

### `init(name:properties:description:)`

``` swift
public init(name: String, properties: [PropertyModel], description: String?)
```

## Properties

### `name`

``` swift
let name: String
```

### `properties`

``` swift
let properties: [PropertyModel]
```

### `description`

``` swift
let description: String?
```
