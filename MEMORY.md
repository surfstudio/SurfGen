
---
Doesn't support alias which is ref on another type. For exmaple
```
UserID:
    $ref: "#/components/schemas/AnotherType"
```

Idk if we need it. It seems prety strange

**Write test on it**

---

ParametersTreeParser.swift

and in another file in class `Resolver`

we ignore name of alias and we implicitly add type to parameter

so if we have

```
parameters:
    - name: abc
    in: query
    schema:
        UserID:
            type: string
```

then we will have

```
parameters:
    - name: abc
    in: query
    schema:
        type: string
```

idk if we should do cmth with it

----

TreeParser returns arrays caount the same as dependencies count. It looks like a big fall in logic