# Editing templates

Each template expects its own context - data structure used to fill variable gaps in template. Currently we have 4 types of template context:

- Service

- Model

- Enum

- TypeAlias

Each template should be designed according to one of these contexts.

## Service context

Service as data structure is a set of paths, where each path has one or more operations with different http methods like

```yaml
paths:
  /billings/services:       
    get:
    	...
    post:
    	...
```

So in template you have access to the following context:

### Service model

```swift
let name: String // Service name
let paths: [PathModel] // All paths with operations in service
let codingKeys: [String] // List of all query parameter names, used in whole service.
```

### Path model

```swift
let path: String // URL template exactly as in OpenAPI spec
let operations: [OperationModel] // All operations for this path
let name: String // URL template converted to name. Used to identify path.
let pathWithSeparatedParameters: String // URL template converted to string and parameters (if they exist) separated by `+` by each side
let parameters: [ParameterModel] // Parameters, located in path string
```

### Operation model

```swift
let httpMethod: String // For example, "GET"
let summary: String? // Short summary of what the operation does
let description: String? // Verbose explanation of the operation behavior
let pathParameters: [ParameterModel] // Parameters, located in path string
let queryParameters: [ParameterModel] // Parameters, located in query
let requestGenerationModel: DataGenerationModel? // Model, used as request body
let responseGenerationModel: Keyed<DataGenerationModel>? // Model, used as response body. Contains body with first defined key. Keyed.key contains http status code or `default` string. It's a key from response definition in OpenAPI
let allGenerationResponses: [ResponseGenerationModel]? //  Contains all responses from this operation
```

#### Keyed

```Swift
let key: String
let value: Any
```

### Response Genration Model

```Swift
let key: String // Contains http status code or `default` string. It's a key from response definition in OpenAPI (same as is DataGenerationModel)
let responses: [DataGenerationModel] // All response' bodies from specific operation grouped by `Key` (by status code, in other words)
```


### Parameter model

```swift
let componentName: String? // Name used in parameter component in OpenAPI
let name: String // Name used in URL     
let description: String?
let isRequired: Bool
let typeModel: ItemTypeModel
```

### Item Type model

```swift
let name: String
let isArray: Bool
let isObject: Bool // True if type is a ref to model or array with ref to model
let enumTypeName: String? // If type is enum, this is enum's primitive type name
let aliasTypeName: String? // If type is alias of primitive type, this is the real primitive type name
```



### DataGenerationModel

```swift

let encoding: String // Content encoding, like "application/json"
let typeNames: [String] // List of model names or plain type names, which can be in content body. Has multiple elements only in case of 'oneOf' group in content body description
let isTypeArray: Bool // True if type is array of some type
let isTypeObject: Bool // True if type is a ref to model or array with ref to model 
```



## Model context

Model as data structure describes schema object in OpenAPI.

### SchemaObjectModel

```swift
let name: String // Model name
let properties: [PropertyModel] // All fields
let description: String?
```

### PropertyModel

```swift
let name: String // Property name
let description: String?
let isNullable: Bool // True if property is not required
let typeModel: ItemTypeModel
```



## Enum context

### SchemaEnumModel

```swift
let name: String // Enum name
let cases: [String] // List of possible values
let generatedType: String // Type of values, one of  ["string", "integer", "number"]
let description: String?
```



## Type alias context

### PrimitiveTypeAliasModel

```swift
let name: String // Alias name
let typeName: String // Name of primitive type, which is replaced by this alias, one of  ["string", "integer", "number", "boolean"]
```



## Applying filters to context values

Stencil language has filter system which is explained at [Stencil Docs](https://stencil.fuller.li/en/latest/builtins.html#built-in-filters)

In addition to Stencil`s built-in filters we have some custom ones.

- `capitalizeFirstLetter` Capitalizes first letter of a string but doesn't touch the rest of string. Example: `"exampleText" -> "ExampleText"`
- `lowercaseFirstLetter` Makes first letter of a string lowercase but doesn't touch the rest of string. Example: "`ExampleText" -> "exampleText"`
-  `snakeCaseToCamelCase` Example: `"example_text" -> "exampleText"`
-  `camelCaseToSnakeCase` Example: `"exampleText" -> "example_text"`
- `camelCaseToCaps` Example: "`exampleText" -> "EXAMPLE_TEXT"`
- `trim` Example: `"\n   exampleText       " -> "exampleText" `
- `splitLines` Returns list of strings, made by splitting input string by "\n" symbol. Example: `"example\nstring" -> ["example", "string"]`
- `upperCaseToCamelCase` Example: `"EXAMPLE_TEST" -> "exampleTest"`. For details see [tests](./Tests/CommonTests/ExtensionsTests/StringTests.swift)
- `upperCaseToCamelCaseOrSelf` works just like previous BUT firstly check that string contains only uppercased letters (except `_`). And if it is - do `upperCaseToCamelCase`, otherwise returns string without changes. Useful for conditional filters pipelining
