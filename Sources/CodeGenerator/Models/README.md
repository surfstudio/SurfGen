#  Code Generator Data Structure

There is specific data structure that provides constraints on how the specification should look like (and how entities it it should be linked witheach other). And this contraints is a nature consequence of how Swift types relate with each other.

So it means that this data structure in ither words just a set of rule about how to specification should looks

## Components

It's about `components:` part of specification. At this moment there may be only `schemas:` and `parameters:`

### Schemas

It's about `schemas:`

Look at `SchemaType.swift`

`Schema` must be:
- `enum`
- `object`
- `primitive`

```YAML
components:
    schemas:
    
        AnyEnum:
            type: string
            enum: [pm, teamlead, developer, qa, analyst, none]
            
        AnyObject:
            type: object
            properties:
                prop1:
                    type: string
                prop2:
                    $ref:"#/components/schemas/AnyEnum"
                    
        AnyPrimitive:
            type: string
```

Then `enum`'s type must be only `primitive`

---

`object`'s properties type must be:
- `primitive`
- `reference(Schema)`
- `array(PropertyType)`


Look at `SchemaObjectModel.swift`

As you can see, we can't parse yet another declaration inside  `object`'s properties

And the `reference` may only refers to `Schema`. So it means that you mustn't write reference to `parameter`

---

### Parameters

It's about `parameters:`

Any parameter's type must be:
- `primitive`
- `reference(Schema)`
- `array(ParameterType)`

```YAML
parameters:
  limit: 
    name: limit
    in: query
    description: Размер пачки пагинации
    schema:
      $ref: "..."
  offset:
    name: offset
    in: query
    description: Сдвиг пагинации
    schema:
      type: integer
```
