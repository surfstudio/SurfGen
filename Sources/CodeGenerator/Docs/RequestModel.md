# RequestModel

Describes `request body` part of API method

``` swift
public struct RequestModel: Encodable
```

``` YAML
components:
    requestBodies:
        ServiceStatus:
            content:
                "application/json":
                    schema:
                        $ref: "models.yaml#/components/schemas/ServiceStatus"
```

## Serialization schema

``` YAML
RequestModel:
    type: object
    properties:
        description:
            type: string
        isRequired:
            type: boolean
        content:
            type: array
            items:
                $ref: "data_model.yaml#/components/schemas/DataModel"
```

## Inheritance

`Encodable`

## Properties

### `description`

Description which was proided (or not) in specification

``` swift
let description: String?
```

### `content`

``` swift
let content: [DataModel]
```

### `isRequired`

``` swift
let isRequired: Bool
```
