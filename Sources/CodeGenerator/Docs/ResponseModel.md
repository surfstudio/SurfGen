# ResponseModel

Describes specific response

``` swift
public struct ResponseModel: Encodable
```

``` YAML
components:
    responses:
        ServiceStatus:
            content:
                "application/json":
                    schema:
                        $ref: "models.yaml#/components/schemas/ServiceStatus"
```

## Serialization schema

``` YAML
ResponseModel:
    type: object
    properties:
        key:
            type: string
        values:
            type: array
            items:
                $ref: "data_model.yaml#/components/schemas/DataModel"
```

## Inheritance

`Encodable`

## Properties

### `key`

May be `statusCode` or `default` string

``` swift
let key: String
```

### `values`

Possible results

``` swift
let values: [DataModel]
```
