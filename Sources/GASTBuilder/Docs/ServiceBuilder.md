# ServiceBuilder

Just an interface for any GAST-Service builder

``` swift
public protocol ServiceBuilder
```

## Requirements

### build(paths:​)

Build all item which are under `paths:​`

``` swift
func build(paths: [Path]) throws -> [PathNode]
```
