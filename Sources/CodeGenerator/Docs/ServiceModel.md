# ServiceModel

Describes service (or one `path`)

``` swift
public struct ServiceModel: Encodable
```

``` YAML
/billings/payment:
  post:
    parameters:
      - name: smartCardOrAgreement
        required: false
        in: query
        schema:
          type: string
    requestBody:
      required: true
      content:
        application/json:
          schema:
            $ref: "models.yaml#/components/schemas/PaymentDetailsRequest"
    responses:
      "200":
        content:
          application/json:
            schema:
              $ref: "models.yaml#/components/schemas/PaymentDetailsResponse"
  get:
    responses:
      "200":
        content:
          application/json:
            schema:
              $ref: "models.yaml#/components/schemas/UserContactInfo"
```

## Serialization schema

``` YAML

Type:
    type: string
    enum: ['object', 'group']

SchemaGroupType:
    type: string
    enum: ['oneOf', 'onyOf', 'allOf']

PossibleType:
    type: object
    properties:
        type:
            type:
                $ref: "#/components/schemas/Type"
        value:
            type:
                schema:
                    oneOf:
                        - $ref: "schema_object_model.yaml#/component/schemas/SchemaObjectModel"
                        - $ref: "schema_group_model.yaml#/component/schemas/SchemaGroupModel"

ServiceModel:
    type: object
    prperties:
        path:
            type: string
        operations:
            type: array
            items:
                $ref: "operation_model.yaml#/components/schemas/OperationModel"
```

## Inheritance

`Encodable`

## Properties

### `path`

URI template

``` swift
let path: String
```

### `operations`

``` swift
let operations: [OperationModel]
```
