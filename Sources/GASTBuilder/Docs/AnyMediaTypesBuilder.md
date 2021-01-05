# AnyMediaTypesBuilder

Default implementation of MediaTypesBuilder

``` swift
public struct AnyMediaTypesBuilder: MediaTypesBuilder
```

## Don't support

### MediaType content must be a `reference`. Other in-place declaration itsn't supported. Because it that case we can't generate model

## Inheritance

[`MediaTypesBuilder`](./MediaTypesBuilder)

## Initializers

### `init(schemaBuilder:enableDisclarationChecking:)`

``` swift
public init(schemaBuilder: SchemaBuilder, enableDisclarationChecking: Bool = true)
```

## Properties

### `schemaBuilder`

``` swift
let schemaBuilder: SchemaBuilder
```

### `enableDisclarationChecking`

If set to `false` disable errors for cases when MediaType schema cotains definition of object/enum/alias e.t.c
If set to `true` throws error for any case except reference
By default set to `true`

``` swift
let enableDisclarationChecking: Bool
```

**WARNING**
Don't touch it in SurfGen code

## Methods

### `buildMediaItems(items:)`

``` swift
public func buildMediaItems(items: [String: MediaItem]) throws -> [MediaTypeObjectNode]
```