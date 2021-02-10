# ReferenceExtractor

This class extracts all references (`$ref` tag) from specific OpenAPI specification file recursively

``` swift
public class ReferenceExtractor
```

For example:
We have file at path`../api/billings/api.yaml`
Inside this file we have some REST methods which contain references on some models in another spec files.

`ReferenceExtractor` will extract referenced files' pathes
And also it will read each file and will make the same extraction
And it will repeat it until it read all dependencies

`ReferenceExtractor` is proof to reference cycles

**ATTENTION**
Doesn't exclude local references. SO if ypu have reference which is local (wihtout file path before `#`)
Extractor doesn't return it in result array.

**WARNING**
Isn't thread-safe\!
If you want to working in parallel, you should create different instances of this class

**NOTICE**
May be tricky with refs which were inserted in an array

## Initializers

### `init(pathToSpec:fileProvider:)`

Initializer

``` swift
public init(pathToSpec: URL, fileProvider: FileProvider) throws
```

#### Parameters

  - pathToSpec: Path to YAML specification from which yupu need to extract references
  - fileProvider: Will be used for reading strings in utf8 encoding

#### Throws

  - CustomError:​ In case when file at `pathToSpec` isn't readable

## Methods

### `extract()`

**WARNING**
Doesn't return link on `rootSpecPath`
If you need it you shoul do it by yourself

``` swift
public func extract() throws -> (uniqRefs: [String], dependecies: [Dependency])
```
