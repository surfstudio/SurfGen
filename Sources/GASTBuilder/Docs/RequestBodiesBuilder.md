# RequestBodiesBuilder

The same as `RequestBodyBuilder` can build bodies which are declared in `components.requestBodies`

``` swift
public protocol RequestBodiesBuilder
```

## Requirements

### build(requestBodies:​)

``` swift
func build(requestBodies: [ComponentObject<RequestBody>]) throws -> [ComponentRequestBodyNode]
```
