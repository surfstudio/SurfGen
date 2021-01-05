# CommonError

Must be used Error
Contains meta information about error
whis is useful for debugging and understading in `What was happen?!`

``` swift
public struct CommonError: LocalizedError
```

Must be used in all cases except some specific sutuations
To print error information you need to call `errorDescription`

Contains factory of `stub errors`

## Inheritance

`LocalizedError`

## Initializers

### `init(message:line:function:column:file:)`

``` swift
public init(message: String, line: Int = #line, function: String = #function, column: Int = #column, file: String = #file)
```

## Properties

### `errorDescription`

``` swift
var errorDescription: String?
```

## Methods

### `notInplemented(line:function:column:file:)`

Factory of `notImplemented` stub.
Use in all cases where you want to write `TODO:​ ..`

``` swift
public static func notInplemented(line: Int = #line, function: String = #function, column: Int = #column, file: String = #file) -> CommonError
```

For example. If you create method:

``` Swift
func doSmth(param: SomeParams) throws -> SomeData {
    ....
}
```

Then if you try to compile this code you will get compilation error
because method doesn't have a `return` expression. So:

``` Swift
func doSmth(param: SomeParams) throws -> SomeData {
    return .init(param: "", param2: 1...)
}
```

**BUT DON"T DO IT**

**DONT WRITE STUB IMPLEMENTATION**

Instead, write:

``` Swift
func doSmth(param: SomeParams) throws -> SomeData {
    throws CommonError.notInplemented()
}

```

And then you can continue writing code, tests and so on
And when execution will call your code
Your tests will crash with error.
