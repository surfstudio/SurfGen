# Reference

Wrapper on type
In many elemnts of specifiation we may have `in-place` declaration
and `reference` declration

``` swift
public enum Reference<DataType>
```

For example:

``` 
components:
    schemas:
        InPlaceObject:
            properties:
                field:
                    type: integer # <-- This is `in-place` declaration

        RefObject:
            properties:
                field:
                    $ref: "#components/schemas/InPlaceObject" # <-- This is `refernce` declaration
```

`DataType` is a type of component (SchemaObject, Enum, etc.)

## Serialization schema

\*\* WATCH OUT\*\*

Each component serialization schema contains its own reference declaration. Because OpenAPI doesn't support generics

This declaration just an example.

``` YAML
ReferenceType:
    type: object
    properties:
        isReference:
            description: True if this is reference
            type: bool
        value:
            description: Specific value. Enum, Object, e.t.c
            type: Any
```

## Inheritance

`Encodable`

## Enumeration Cases

### `reference`

``` swift
case reference(: DataType)
```

### `notReference`

``` swift
case notReference(: DataType)
```
