# ParametersBuilder

Just an interface for any GAST-Parameter builder

``` swift
public protocol ParametersBuilder
```

## Requirements

### build(parameters:​)

Can build `parameter`

``` swift
func build(parameters: [ComponentObject<Parameter>]) throws -> [ParameterNode]
```
