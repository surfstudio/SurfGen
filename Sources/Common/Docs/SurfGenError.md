# SurfGenError

Just a wrapper on other errors
Tha main feature is that whis error implemntation can print error tree with shifts

``` swift
public struct SurfGenError: LocalizedError
```

For example. If we have:

``` Swift

SurfGenError(nested: CustomError(message: "Can't parse `schema` inside `path` declaration"), message: "While parsing \(path)")
```

The we will get:

``` 
While parsing GET
    Can't parse `schema` inside `path` declaration
```

And for more comfortable wrapping there is a global `wrap` method

You should use `wrap` instead create this instance directly

``` Swift

wrap(
    CustomError(message: "Can't parse `schema` inside `path` declaration"),
    message: "While parsing \(path)"
)
```

## Inheritance

`LocalizedError`

## Initializers

### `init(nested:message:)`

``` swift
public init(nested: Error, message: String)
```

## Properties

### `errorDescription`

``` swift
var errorDescription: String?
```

### `rootError`

``` swift
var rootError: Error
```
