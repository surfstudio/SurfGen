# PropertyModel.PossibleType

``` swift
public enum PossibleType
```

## Inheritance

`Encodable`

## Enumeration Cases

### `primitive`

``` swift
case primitive(: PrimitiveType)
```

### `reference`

``` swift
case reference(: SchemaType)
```

### `array`

``` swift
case array(: SchemaArrayModel)
```

## Methods

### `encode(to:)`

``` swift
public func encode(to encoder: Encoder) throws
```
