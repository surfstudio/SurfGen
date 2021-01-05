# SchemaModelNode

Describes entity (Model)
It's object with name, properties, descriptions, e.t.c

``` swift
public struct SchemaModelNode
```

So in terms of development it may be DTO

## Inheritance

[`StringView`](./StringView)

## Initializers

### `init(name:properties:description:)`

``` swift
public init(name: String, properties: [PropertyNode], description: String?)
```

## Properties

### `name`

``` swift
let name: String
```

### `properties`

``` swift
let properties: [PropertyNode]
```

### `description`

``` swift
let description: String?
```

### `view`

``` swift
var view: String
```
