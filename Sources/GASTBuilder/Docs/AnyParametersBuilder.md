# AnyParametersBuilder

Default implementation for `ParametersBuilder`.
Can build parameters both from `components.parameters` and from `paths.operations.parameters`

``` swift
public struct AnyParametersBuilder: ParametersBuilder
```

  - See: https://swagger.io/docs/specification/describing-parameters/

## Don't support

### Content in paramter's type. You cant declare `schema` in parameter's type

For example it's **ok**:

``` YAML
 Param1:
    type: integer

 Param2:
    type:
        $ref: "..."
```

But it's **not**

``` YAML
 Param1:
    type:
        content:
            type: object
            ....
```

## Inheritance

[`ParametersBuilder`](./ParametersBuilder)

## Initializers

### `init(schemaBuilder:)`

``` swift
public init(schemaBuilder: SchemaBuilder)
```

## Methods

### `build(parameters:)`

``` swift
public func build(parameters: [ComponentObject<Parameter>]) throws -> [ParameterNode]
```
