# Template

This model keeps information about template and file generated with this template

``` swift
public struct Template: Decodable
```

## Inheritance

`Decodable`

## Initializers

### `init(type:nameSuffix:fileExtension:templatePath:destinationPath:)`

``` swift
public init(type: Template.TemplateType, nameSuffix: String?, fileExtension: String, templatePath: String, destinationPath: String)
```

## Properties

### `type`

``` swift
let type: TemplateType
```

### `nameSuffix`

All files generated with this template will have this suffix after passed name
Examples: NetworkService, Repository, Urls, Entity

``` swift
let nameSuffix: String?
```

### `fileExtension`

All files generated with this template will have this extension
Examples: swift, dart, kt

``` swift
let fileExtension: String
```


### `fileNameCase`

String case for files, generated with this template
Options: camelCase, snakeCase
Results: TestModelName.txt, test_model_name.txt

``` swift
let fileNameCase: FileNameCase
```

### `templatePath`

Template file location
Example:  Path/To/Project/SurfGenTemplates/example.txt

``` swift
let templatePath: String
```

### `destinationPath`

Where to place file generated with this template
If some directories are missing, they will be generated automatically
All entries of `{name}` will be replaced with the name of passed context (model, service, etc)
It allows you to group files by name
Example: Path/To/Project/Models/{name}

``` swift
let destinationPath: String
```
