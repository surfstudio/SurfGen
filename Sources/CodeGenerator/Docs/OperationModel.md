# OperationModel

Describes an API method

``` swift
public struct OperationModel: Encodable
```

Operation it's specific CRUD method.

For example if we have method with uri: `www.example.com/projects/users`

this method can be `GET /projects/users` for reading information

Or it can be `POST /projects/users` to create new user for projectsэто

And each of those (`GET` and `POST`) will be a different `OperationModel`

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
```

## Serialization schema

``` YAML

ParametersRef:
    type: object
    properties:
        isReference:
            type: bool
        value:
            type:
                $ref: "parameter_model.yaml#/components/schemas/ParameterModel"

ResponseModelRef:
    type: object
    properties:
        isReference:
            type: bool
        value:
            type:
                $ref: "response_model.yaml#/components/schemas/ResponseModel"

RequestModelRef:
    type: object
    properties:
        isReference:
            type: bool
        value:
            type:
                $ref: "request_model.yaml#/components/schemas/RequestModel"

OperationModel:
    type: object
    properties:
        httpMethod:
            type: string
        description:
            type: string
            nullable: true
        parameters:
            nullable: true
            type: array
            items:
                $ref: "#components/schemas/ParametersRef"
        responses:
            nullable: true
            type: array
            items:
                $ref: "#components/schemas/ResponseModelRef"
        responses:
            nullable: true
            type:
                $ref: "#components/schemas/ResponseModelRef"
```

## Inheritance

`Encodable`

## Properties

### `httpMethod`

http method string representation

``` swift
let httpMethod: String
```

For example `GET`

### `description`

Description which was proided (or not) in specification

``` swift
let description: String?
```

### `parameters`

Path and query parameters of specific operations

``` swift
let parameters: [Reference<ParameterModel>]?
```

### `responses`

``` swift
let responses: [Reference<ResponseModel>]?
```

### `requestModel`

``` swift
let requestModel: Reference<RequestModel>?
```
