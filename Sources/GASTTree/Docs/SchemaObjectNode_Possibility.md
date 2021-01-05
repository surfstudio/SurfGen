# SchemaObjectNode.Possibility

``` swift
public indirect enum Possibility
```

## Enumeration Cases

### `object`

``` swift
case object(: SchemaModelNode)
```

### `` `enum` ``

``` swift
case `enum`(: SchemaEnumNode)
```

### `simple`

``` swift
case simple(: PrimitiveTypeAliasNode)
```

### `reference`

``` swift
case reference(: String)
```

### `array`

``` swift
case array(: SchemaArrayNode)
```

### `group`

``` swift
case group(: SchemaGroupNode)
```
