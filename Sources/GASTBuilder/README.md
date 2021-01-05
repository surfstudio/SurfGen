# Types

  - [AnyMediaTypesBuilder](./Docs/AnyMediaTypesBuilder.md):
    Default implementation of MediaTypesBuilder
  - [AnyParametersBuilder](./Docs/AnyParametersBuilder.md):
    Default implementation for `ParametersBuilder`.
    Can build parameters both from `components.parameters` and from `paths.operations.parameters`
  - [AnyRequestBodiesBuilder](./Docs/AnyRequestBodiesBuilder.md):
    Default implementation for both `RequestBodyBuilder` and `RequestBodiesBuilder`
  - [AnyResponsesBuilder](./Docs/AnyResponsesBuilder.md):
    Default implementation of both `ResponseBuilder` and `ResponsesBuilder`
  - [AnySchemaBuilder](./Docs/AnySchemaBuilder.md):
    Default implementation of `schema` builder.
  - [AnyServiceBuilder](./Docs/AnyServiceBuilder.md):
    Default implementation for `ServiceBuilder`
    Builds `path` elements of Open-API spec
  - [AnyGASTBuilder](./Docs/AnyGASTBuilder.md):
    Parse `API specification` to `OpenAPI-AST` then build the `GAST` from it.

# Protocols

  - [MediaTypesBuilder](./Docs/MediaTypesBuilder.md):
    Just an interface for any GAST-MediaType builder
  - [ParametersBuilder](./Docs/ParametersBuilder.md):
    Just an interface for any GAST-Parameter builder
  - [RequestBodyBuilder](./Docs/RequestBodyBuilder.md):
    Just an interface for any GAST-RequestBody builder
  - [RequestBodiesBuilder](./Docs/RequestBodiesBuilder.md):
    The same as `RequestBodyBuilder` can build bodies which are declared in `components.requestBodies`
  - [ResponseBuilder](./Docs/ResponseBuilder.md):
    Just an interface for any GAST-response builder
  - [ResponsesBuilder](./Docs/ResponsesBuilder.md):
    The same as `ResponseBuilder` but can build `components.responses`
  - [SchemaBuilder](./Docs/SchemaBuilder.md):
    Just an interface for any GAST-Schema builder
  - [ServiceBuilder](./Docs/ServiceBuilder.md):
    Just an interface for any GAST-Service builder
  - [GASTBuilder](./Docs/GASTBuilder.md):
    Just an interface for any `GAST` builder
