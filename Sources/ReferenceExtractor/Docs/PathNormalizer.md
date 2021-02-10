# PathNormalizer

Namspace for path normalization operations

``` swift
public enum PathNormalizer
```

## Methods

### `normalize(path:)`

Removes any `relativity` from path
For example:​

``` swift
public static func normalize(path: String) throws -> String
```

``` 
dirA/dirB/../dirC
```

will normalized to:

``` 
"dirA/dirC"
```

For details look in `PathNormalizerTests`
