
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
