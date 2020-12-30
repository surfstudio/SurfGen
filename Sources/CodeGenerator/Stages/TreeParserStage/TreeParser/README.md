# Tree Parser

This is GASTree parser. 

It convert `GAST` to `Code Generator Models` but, even more, it resolve references and embed refrenced components in components which contains references.

## How does it works

There is a main entry point - `TreeParser` swift structure. It takes an array of `DependencyWithTree` swift structures and then the magic will start.

`TreeParser` can parse all elements of OpenAPI. It contains parsers for each components. And each subparser contains its own subparser for more specific OpenAPI elements.

## Resolver

The most interesting part is `Reference Resolving` and `Resolver` deal with it.

In terms of this class there are some definitions:
- `Local reference` - `$ref` which hasn't a path to file. For example this is reference is local --> `$ref: #/components/schemas/Object`
- `Global reference` - `$ref` which has a path. For example --> `$ref: "../../other/path/specification.yaml#/components/schemas/Object"`

> If you want more information about global references - you should look at `PathNormalizerTests.swift`

This class do:
1. Determie what type a reference is - `local` or `global`
2. If reference is `local` then `resolver` will just call `resolve` for current `GAST` -- so it just search for referenced object in this tree
3. If reference is `global`
    1. Search for the tree which is referenced. For example if we have `$ref: "../models.yaml#/components/schemas/Object"` which is declared in file at path `/user/repo/project/swagger/controllers/catalog/api.yaml`. And while we parsing this file we find the `$ref`. And it means that we nned to search for the `GAST` tree which has the same file path (we have all GAST with their pathes in `DependencyWithTree` array). So now we have GAST which is located in `/user/repo/project/swagger/controllers/models.yaml` (because of `../` in `$ref`) or we have an error and the process will be terminated (:
    2. After we get the specific tree we will make step `2` but especially for this tree.
4. Thet we check. If resolved component has nested references (like when we has ref on Object which has property whose type is `$ref`...)
5. If it is then we will continue from `1` step
6. If it isn't then we ends resolving

**About refrence cycles**

This the case:

```YAML

schemas:

    CycledA:
        type: object
        properties:
            cycle:
                $ref: "#/components/schemas/CycledB"

    CycledB:
        type: object
        properties:
            cycle:
                $ref: "#/components/schemas/CycledA"
```

Resolver can determine a situation such situations, but it can't resolve it. Because in code generation it's a cuncern. For example:

```Swift
struct A {
    var b: B
}

struct B {
    var a: A
}

A(b: B(a: A(b: B(.....))))
```

And we think that situation like this is not the best situation. And can be a sign of design issue. Because of this at this moment SurfGen will throws an error if refrence cycle was found.

