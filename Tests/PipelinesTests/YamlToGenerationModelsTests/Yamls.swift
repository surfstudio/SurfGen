//
//  File.swift
//  
//
//  Created by Александр Кравченков on 19.12.2020.
//

import Foundation

extension ParametersTests {
    /// Contains service `messages` with one operation `get`
    /// And the operation contains two parameters `id2` and `id3` with `integer` and `string` types
    /// Each parameter is declared `in place`
    /// Contains one response with type `string`
    static var yamlWithPrimitiveTypeInPlaceWillBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          parameters:
            - name: id2
              required: true
              in: path
              schema:
                type: integer
            - name: id3
              required: true
              in: path
              schema:
                type: string
          responses:
            "200":
              description: "Все ок"
              content:
                application/json:
                  schema:
                    type: string
""".data(using: .utf8)!

    /// Contains service `messages` with one operation `get`
    /// And the operation contains two parameters `id` with `$ref` (in type) on local `schema` which is enum
    /// Each parameter is declared `in place`
    /// Contains one response with type `string`
    static var yamlParamsWithRefInSchemaOnEnumWillBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          parameters:
            - name: id
              required: true
              in: path
              schema:
                $ref:"#/components/schemas/ServiceStatus"
          responses:
            "200":
              description: "Все ок"
              content:
                application/json:
                  schema:
                    type: string
    components:
        schemas:
            ServiceStatus:
              type: string
              enum: [active, inactive, blocked]
              description: Статус услуги
""".data(using: .utf8)!


    /// Contains service `messages` with one operation `get`
    /// And the operation contains two parameters `id` with `$ref` (in type) on local `schema` which is object
    /// Each parameter is declared `in place`
    /// Contains one response with type `string`
    static var yamlParamsWithRefInSchemaOnObjectWillBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          parameters:
            - name: id
              required: true
              in: path
              schema:
                $ref:"#/components/schemas/ServiceStatus"
          responses:
            "200":
              description: "Все ок"
              content:
                application/json:
                  schema:
                    type: string
    components:
        schemas:
            ServiceStatus:
              type: object
              properties:
                email:
                  type: string
              description: Статус услуги
""".data(using: .utf8)!

    /// Contains service `messages` with one operation `get`
    /// And the operation contains two parameters `id` with `$ref` (in type) on local `schema` which is alias
    /// Each parameter is declared `in place`
    /// Contains one response with type `string`
    static var yamlParamsWithRefInSchemaOnAliasWillBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          parameters:
            - name: id
              required: true
              in: path
              schema:
                $ref:"#/components/schemas/ServiceStatus"
          responses:
            "200":
              description: "Все ок"
              content:
                application/json:
                  schema:
                    type: string
    components:
        schemas:
            ServiceStatus:
              type: string
              description: Статус услуги
""".data(using: .utf8)!

    /// Contains service `messages` with one operation `get`
    /// And the operation contains two parameters `id` with `$ref` (in type) on `schema` in another file `models.yaml`
    /// Each parameter is declared `in place`
    /// Contains one response with type `string`
    static var yamlParamsWithRefInSchemaOnAnotherFileWillBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          parameters:
            - name: id
              required: true
              in: path
              schema:
                $ref:"models.yaml#/components/schemas/ServiceStatus"
          responses:
            "200":
              description: "Все ок"
              content:
                application/json:
                  schema:
                    type: string
    components:
        schemas:
            ServiceStatus:
              type: string
              description: Статус услуги
""".data(using: .utf8)!

    /// Contains service `messages` with one operation `get`
    /// And the operation contains two parameters `id` with `$ref` (in type) on cycled objects
    ///
    /// Each parameter is declared `in place`
    /// Contains one response with type `string`
    static var yamlParamsWithRefOnCycledObjectsWillParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          parameters:
            - name: id
              required: true
              in: path
              schema:
                $ref:"models.yaml#/components/schemas/CycledA"
          responses:
            "200":
              description: "Все ок"
              content:
                application/json:
                  schema:
                    type: string
    components:
        schemas:
            ServiceStatus:
              type: string
              description: Статус услуги
""".data(using: .utf8)!

    /// Contains:
    ///
    /// Schemas:
    ///     - ServiceStatus:
    ///         - Alias: String
    ///     - CycledA and CycledB
    ///         - Object
    ///         - objects that refer to each other (reference cycle)
    static var yamlSeparatedModels = """
    components:
        parameters:
            Param:
              name: id
              required: true
              in: path
              schema:
                $ref:"#/components/schemas/ServiceStatus"

        schemas:
            ServiceStatus:
              type: string
              description: Статус услуги

            CycledA:
              type: object
              properties:
                cycle:
                  type:
                    $ref: "#/components/schemas/CycledB"

            CycledB:
              type: object
              properties:
                cycle:
                  type:
                    $ref: "#/components/schemas/CycledA"
""".data(using: .utf8)!

    /// Contains service `messages` with one operation `get`
    /// And the operation contains two parameters `id` with `$ref` (in type) on `parameters`
    ///
    /// Contains one response with type `string`
    static var yamlRefOnParamWillBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          parameters:
            $ref: "models.yaml#/components/parameters/Param"
          responses:
            "200":
              description: "Все ок"
              content:
                application/json:
                  schema:
                    type: string
    components:
        schemas:
            ServiceStatus:
              type: string
              description: Статус услуги
""".data(using: .utf8)!
}
