# Types

  - [AnyMediaTypesBuilder](./AnyMediaTypesBuilder.md):
    Default implementation of MediaTypesBuilder
  - [AnyParametersBuilder](./AnyParametersBuilder.md):
    Default implementation for `ParametersBuilder`.
    Can build parameters both from `components.parameters` and from `paths.operations.parameters`
  - [AnyRequestBodiesBuilder](./AnyRequestBodiesBuilder.md):
    Default implementation for both `RequestBodyBuilder` and `RequestBodiesBuilder`
  - [AnyResponsesBuilder](./AnyResponsesBuilder.md):
    Default implementation of both `ResponseBuilder` and `ResponsesBuilder`
  - [AnySchemaBuilder](./AnySchemaBuilder.md):
    Default implementation of `schema` builder.
  - [AnyServiceBuilder](./AnyServiceBuilder.md):
    Default implementation for `ServiceBuilder`
    Builds `path` elements of Open-API spec
  - [AnyGASTBuilder](./AnyGASTBuilder.md):
    Parse `API specification` to `OpenAPI-AST` then build the `GAST` from it.

# Protocols

  - [MediaTypesBuilder](./MediaTypesBuilder.md):
    Just an interface for any GAST-MediaType builder
  - [ParametersBuilder](./ParametersBuilder.md):
    Just an interface for any GAST-Parameter builder
  - [RequestBodyBuilder](./RequestBodyBuilder.md):
    Just an interface for any GAST-RequestBody builder
  - [RequestBodiesBuilder](./RequestBodiesBuilder.md):
    The same as `RequestBodyBuilder` can build bodies which are declared in `components.requestBodies`
  - [ResponseBuilder](./ResponseBuilder.md):
    Just an interface for any GAST-response builder
  - [ResponsesBuilder](./ResponsesBuilder.md):
    The same as `ResponseBuilder` but can build `components.responses`
  - [SchemaBuilder](./SchemaBuilder.md):
    Just an interface for any GAST-Schema builder
  - [ServiceBuilder](./ServiceBuilder.md):
    Just an interface for any GAST-Service builder
  - [GASTBuilder](./GASTBuilder.md):
    Just an interface for any `GAST` builder
