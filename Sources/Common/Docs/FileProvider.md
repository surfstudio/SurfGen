# FileProvider

Interface for object which can deal with files in file system

``` swift
public protocol FileProvider
```

## Requirements

### isReadableFile(at:​)

``` swift
func isReadableFile(at path: String) -> Bool
```

### readFile(at:​)

``` swift
func readFile(at path: String) throws -> Data?
```
