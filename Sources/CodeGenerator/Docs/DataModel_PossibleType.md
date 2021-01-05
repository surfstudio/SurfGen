# DataModel.PossibleType

Possibe API entities which can be used in this model

``` swift
public enum PossibleType
```

## Inheritance

`Encodable`

## Enumeration Cases

### `object`

``` swift
case object(: SchemaObjectModel)
```

### `array`

``` swift
case array(: SchemaArrayModel)
```

### `group`

``` swift
case group(: SchemaGroupModel)
```

## Methods

### `encode(to:)`

``` swift
public func encode(to encoder: Encoder) throws
```
