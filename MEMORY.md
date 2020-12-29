
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

---

Doesn't support response headers

---

Schek that ref to RequestBody from another RequestBody leads to error throwing

---

content:
  application/json:
    schema:
      type: array
      items:
        $ref: "../billings/models.yaml#/components/schemas/Tariffs"
        
Isn't supported, but if array is decalared in components then it will work ok

---

/resources/config: 
  get:
    summary: Метод конфига
    description: >
      Здесь будет возвращаться конфиг для приложения.
      Представляет из себя словарь со вложенными словарями:
      {"common": "error": {"noNetwork": "text"}}}
      Полную конфигурацию можно посмотреть $ссылка
    responses:
      "200":
        description: Успех
        content:
          application/json:
            schema:
              type: object
              additionalProperties: {}
      default:
        $ref: "../errors.yaml#/components/responses/ApiErrorResponse"

we can't parse it. Because of in-lace definition of additionalProperties. And have no idea how to parse it

---

/feedback/attachments:
  post:
    summary: Файлы для обратной связи
    requestBody:
      required: true
      content:
        multipart/form-data:
          schema:
            properties:
              file:
                type: string
                format: binary
                
