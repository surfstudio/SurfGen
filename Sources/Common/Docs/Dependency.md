# Dependency

It's like a node of dependency graph.
But this struct describes one file of API specification

``` swift
public struct Dependency
```

It's a file and its dependencies which are key-value pairs

For example. Lets imagine that we have 3 files.
File `a.yaml`, `b.yaml`, `c.yaml`

And lets file `a.yaml` contains 2 `$ref` on `b.yaml`
and 1 `$ref` to file `c.yaml`
(like this `$ref: "c.yaml#/components/schemas/SomeSchema"`)

Then `Dependency` object for `a.yaml` will look like:

``` JSON
{
    "pathToCurrentFile": "a.yaml",
    "dependecies": {
        "b.yaml#/components/schemas/SomeSchema": "b.yaml",
        "c.yaml#/components/schemas/SomeSchema": "c.yaml"
    }
}
```

**WARNING**

`path` depend on implementation of dependency extractor

For example it may be full path.

## Initializers

### `init(pathToCurrentFile:dependecies:)`

``` swift
public init(pathToCurrentFile: String, dependecies: [String: String])
```

## Properties

### `pathToCurrentFile`

``` swift
let pathToCurrentFile: String
```

### `dependecies`

Key is $ref value
Value is full path to file which is referenced by key

``` swift
var dependecies: [String: String]
```
