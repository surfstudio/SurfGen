#  Code Generator Data Structure

Notice 1: 
> For better understading look at code which will be mentioned in this file. In common, each data structure contains nesten `enum` which is determine what types of `type` this data-type can hold.

There is specific data structure that provides constraints on how the specification should look like (and how entities it it should be linked witheach other). And this contraints is a nature consequence of how Swift types relate with each other.

This data structure is created through parsing `GASTree` by `TreeParser` and at [this place](../Stages/TreeParserStage/TreeParser/README.md) you can learn more

Notice 2:
> That is the final data structure before code generation. But some pipelines stages can modify this structure.

## Components

Very big part of a OpenAPI spicification is `components`.
According to documentation this part contains some of the nested parts:
- `schemas` - part for data models and data types
- `parameters` - part for request parameters
- `requestBodies` - part for reusable request bodies declaration
- `responses` - part for reusable response bodies desclaration
- `headers` - part for reusable headers [**UNSUPPORTED**]

```YAML
components:
    schemas:
    
    parameters:
    
    requestBodies:
    
    responses:
    
    headers:
```

There is no data structure that fits this OpenAPI element, because we want to process each subcomponent independently of other.

But each sub component has specific data structure.

### Schemas

May contains defintions of:
- Object - `SchemaObjectModel` swift structure
- Alias (primitive type with custom name) - `PrimitiveTypeAliasModel`  swift structure
- Enum  - `SchemaEnumModel`  swift structure
- Group (oneOf, allOf, anyOf) - `SchemaGroupModel` swift structure
- Array - `SchemaArrayModel` swift structure

And may looks like that:

```YAML
schemas:
    Object:                     # <-- Name
        type: object            # <-- Type
        properties:             # <-- object fields
            field1:             # <-- field name
                type: string    # <-- field schema
    
    Alias:
        type: string
    
    Enum:
        type: string
        enum: ["One", "Two", "Three"]
    
    GroupOneOf:
        oneOf:
            - $ref: "#componentns/schemas/Object1"
            - $ref: "#componentns/schemas/Object2"

    GroupAllOf:
        allOf:
            - $ref: "#componentns/schemas/Object1"
            - $ref: "#componentns/schemas/Object2"
            
    GroupAllOf:
        oneOf:
            - $ref: "#componentns/schemas/Object1"
            - $ref: "#componentns/schemas/Object2"

    Array:
        type: array
        items:
            $ref: "#/components/schemas/Alias"
```

This components represented as `SchemaType` swift structure

### Parameters

Contains only request parameters definition

For example:

```YAML
parameters:
    
    QueryParameter:                             # <-- Name
        name: id                                # <-- Key in URL
        required: true                          
        in: query                               # <-- Location
        schema:
            $ref: "#/components/schemas/Object"
            
    PathParameter:
        name: id
        required: true
        in: path
        schema:
            type: string
```

This data structure is represented by `ParameterModel` swift structure.

### RequestBodies and Responses

Contains full description of request body:

```YAML
requestBodies:

    CatalogRequest:
        content:
            "application/json":
                schema:
                    $ref: "models.yaml#/components/schemas/Object"

responses:

    CatalogResponse:
        content:
            "application/json":
                schema:
                    $ref: "models.yaml#/components/schemas/Object"
```

And at this stage of SurfGen work this components dont't have a data structure, because they were included in `operation` on the previous step

## Paths

This element contains definition of server's methods.

```YAML
paths:
    /collection/{id}/action:
        parameters:
            - name: id
              in: path
              schema:
                type: string
            - $ref: "models.yaml#/components/schemas/SomeQueryParameter"
        get:
            responses:
                "200":
                    content:
                        application/json:
                            schema:
                                $ref: "models.yaml#/components/schemas/ServiceStatus"
        post:
            requestBody:
                content:
                    "application/json":
                        schema:
                            $ref: "models.yaml#/components/schemas/Object"
            responses:
                "200":
                    content:
                        application/json:
                            schema:
                                $ref: "models.yaml#/components/schemas/Object"


```

This object is represented by `ServiceModel` and it this project `pathes` are commonly called `services`.