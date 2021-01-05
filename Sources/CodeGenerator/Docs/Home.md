# Types

  - [DependencyWithTree](/DependencyWithTree):
    Combines GASTRee and its dependency
    Because we can resolve global references form the `tree` with help of this
  - [ParameterModel](/ParameterModel):
    Method's URI parameter
  - [ParameterModel.PossibleType](/ParameterModel_PossibleType)
  - [PrimitiveTypeAliasModel](/PrimitiveTypeAliasModel):
    Describes alias. Or named primitive type
  - [PropertyModel](/PropertyModel):
    Describes object's property
  - [PropertyModel.PossibleType](/PropertyModel_PossibleType)
  - [Reference](/Reference):
    Wrapper on type
    In many elemnts of specifiation we may have `in-place` declaration
    and `reference` declration
  - [SchemaArrayModel](/SchemaArrayModel):
    Describes array
  - [SchemaArrayModel.PossibleType](/SchemaArrayModel_PossibleType)
  - [SchemaEnumModel](/SchemaEnumModel):
    Describes enum declration with cases.
  - [SchemaGroupModel](/SchemaGroupModel):
    Represents `oneOf`, `allOf` and `anyOf` keywords
  - [SchemaGroupModel.PossibleType](/SchemaGroupModel_PossibleType)
  - [SchemaObjectModel](/SchemaObjectModel):
    This data structure describes schema object.
    In other words:
  - [SchemaType](/SchemaType):
    This is the enumeration of possible schema object
  - [DataModel](/DataModel):
    Data which is used in `RequestModel` and `ResponseModel`
  - [DataModel.PossibleType](/DataModel_PossibleType):
    Possibe API entities which can be used in this model
  - [OperationModel](/OperationModel):
    Describes an API method
    Operation it's specific CRUD method.
  - [RequestModel](/RequestModel):
    Describes `request body` part of API method
  - [ResponseModel](/ResponseModel):
    Describes specific response
  - [ServiceModel](/ServiceModel):
    Describes service (or one `path`)
  - [ServiceGenerationStage](/ServiceGenerationStage)
  - [AnyArrayParser](/AnyArrayParser)
  - [AnyGroupParser](/AnyGroupParser)
  - [AnyMediaTypeParser](/AnyMediaTypeParser)
  - [ParametersTreeParser](/ParametersTreeParser)
  - [RequestBodyParser](/RequestBodyParser)
  - [Resolver](/Resolver):
    This class can resolve references
    It can resolve local references and references to another files
    It can determine referece cycles and throw error with call stack
  - [ResponseBodyParser](/ResponseBodyParser)
  - [TreeParser](/TreeParser)

# Protocols

  - [ArrayParser](/ArrayParser)
  - [GroupParser](/GroupParser)
  - [MediaTypeParser](/MediaTypeParser)
