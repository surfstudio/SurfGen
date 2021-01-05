# Types

  - [DependencyWithTree](./Docs/DependencyWithTree.md):
    Combines GASTRee and its dependency
    Because we can resolve global references form the `tree` with help of this
  - [ParameterModel](./Docs/ParameterModel.md):
    Method's URI parameter
  - [ParameterModel.PossibleType](./Docs/ParameterModel_PossibleType)
  - [PrimitiveTypeAliasModel](./Docs/PrimitiveTypeAliasModel.md):
    Describes alias. Or named primitive type
  - [PropertyModel](./Docs/PropertyModel.md):
    Describes object's property
  - [PropertyModel.PossibleType](./Docs/PropertyModel_PossibleType)
  - [Reference](./Docs/Reference.md):
    Wrapper on type
    In many elemnts of specifiation we may have `in-place` declaration
    and `reference` declration
  - [SchemaArrayModel](./Docs/SchemaArrayModel.md):
    Describes array
  - [SchemaArrayModel.PossibleType](./Docs/SchemaArrayModel_PossibleType)
  - [SchemaEnumModel](./Docs/SchemaEnumModel.md):
    Describes enum declration with cases.
  - [SchemaGroupModel](./Docs/SchemaGroupModel.md):
    Represents `oneOf`, `allOf` and `anyOf` keywords
  - [SchemaGroupModel.PossibleType](./Docs/SchemaGroupModel_PossibleType)
  - [SchemaObjectModel](./Docs/SchemaObjectModel.md):
    This data structure describes schema object.
    In other words:
  - [SchemaType](./Docs/SchemaType.md):
    This is the enumeration of possible schema object
  - [DataModel](./Docs/DataModel.md):
    Data which is used in `RequestModel` and `ResponseModel`
  - [DataModel.PossibleType](./Docs/DataModel_PossibleType.md):
    Possibe API entities which can be used in this model
  - [OperationModel](./Docs/OperationModel.md):
    Describes an API method
  - [RequestModel](./Docs/RequestModel.md):
    Describes `request body` part of API method
  - [ResponseModel](./Docs/ResponseModel.md):
    Describes specific response
  - [ServiceModel](./Docs/ServiceModel.md):
    Describes service (or one `path`)
  - [ServiceGenerationStage](./Docs/ServiceGenerationStage)
  - [AnyArrayParser](./Docs/AnyArrayParser)
  - [AnyGroupParser](./Docs/AnyGroupParser)
  - [AnyMediaTypeParser](./Docs/AnyMediaTypeParser)
  - [ParametersTreeParser](./Docs/ParametersTreeParser)
  - [RequestBodyParser](./Docs/RequestBodyParser)
  - [Resolver](./Docs/Resolver.md):
    This class can resolve references
    It can resolve local references and references to another files
    It can determine referece cycles and throw error with call stack
  - [ResponseBodyParser](./Docs/ResponseBodyParser)
  - [TreeParser](./Docs/TreeParser)

# Protocols

  - [ArrayParser](./Docs/ArrayParser)
  - [GroupParser](./Docs/GroupParser)
  - [MediaTypeParser](./Docs/MediaTypeParser)
