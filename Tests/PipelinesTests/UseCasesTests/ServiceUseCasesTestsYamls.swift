//
//  File.swift
//  
//
//  Created by Александр Кравченков on 27.12.2020.
//

import Foundation

enum ServiceUseCasesTestsYamls {

    static var parametersEmptyParamsWillBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          responses:
            "200":
              description: "Все ок"
              content:
                application/json:
                  schema:
                    type: string

""".data(using: .utf8)!

    static var inPlaceParametersWillBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          parameters:
            - name: id2
              required: true
              in: query
              schema:
                type: integer
          responses:
            "200":
              description: "Все ок"
              content:
                application/json:
                  schema:
                    type: string
""".data(using: .utf8)!

    static var parametersWithRefInTypeWillBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          parameters:
            - name: id2
              required: true
              in: query
              schema:
                $ref: "models.yaml#/components/schemas/ServiceStatus"
          responses:
            "200":
              description: "Все ок"
              content:
                application/json:
                  schema:
                    type: string
""".data(using: .utf8)!

    static var parametersAsRefWillBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          parameters:
            - $ref: "models.yaml#/components/parameters/Param"
            - $ref: "models.yaml#/components/parameters/Param"
            - $ref: "models.yaml#/components/parameters/Param"
          responses:
            "200":
              description: "Все ок"
              content:
                application/json:
                  schema:
                    type: string
""".data(using: .utf8)!

    static var parametersWithDeclarationInTypeWontBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          parameters:
            - name: id2
              required: true
              in: query
              schema:
                type: object
                properties:
                    cycle:
                        $ref: "#/components/schemas/CycledB"
          responses:
            "200":
              description: "Все ок"
              content:
                application/json:
                  schema:
                    type: string
""".data(using: .utf8)!

    static var requestWithRefWillBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          requestBody:
            content:
              "application/json":
                schema:
                    $ref: "models.yaml#/components/schemas/ServiceStatus"
          responses:
            "200":
              description: "Все ок"
              content:
                application/json:
                  schema:
                    type: string
""".data(using: .utf8)!

    static var requestRefOnRequestBodyWillBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          requestBody:
            $ref: "models.yaml#/components/requestBodies/ServiceStatus"
          responses:
            "200":
              description: "Все ок"
              content:
                application/json:
                  schema:
                    type: string
""".data(using: .utf8)!

    static var requestWithSeveralMediaTypesWillBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          requestBody:
            content:
              application/json:
                schema:
                    $ref: "models.yaml#/components/schemas/ServiceStatus"
              application/xml:
                schema:
                    $ref: "models.yaml#/components/schemas/ServiceStatus"
          responses:
            "200":
              description: "Все ок"
              content:
                application/json:
                  schema:
                    type: string
""".data(using: .utf8)!

    static var requestBodyWithDeclarationInSchemaWontBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          requestBody:
            content:
              "application/json":
                schema:
                    type: object
                    properties:
                        cycle:
                            $ref: "models.yaml#/components/schemas/CycledB"
          responses:
            "200":
              description: "Все ок"
              content:
                application/json:
                  schema:
                    type: string
""".data(using: .utf8)!

    static var requestBodyWithoutContentWontBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          requestBody:
                content:
                    "application/json":
          responses:
            "200":
              description: "Все ок"
              content:
                application/json:
                  schema:
                    type: string
""".data(using: .utf8)!

    static var responseWithSeveralMediaTypesWillBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          responses:
            "200":
                content:
                    application/json:
                        schema:
                            $ref: "models.yaml#/components/schemas/ServiceStatus"
                    application/xml:
                        schema:
                            $ref: "models.yaml#/components/schemas/ServiceStatus"
""".data(using: .utf8)!

    static var responseWithDefaultContentWillBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          responses:
            default:
              description: "Все ок"
              content:
                application/json:
                  schema:
                    $ref: "models.yaml#/components/schemas/ServiceStatus"
            "200":
                content:
                    application/json:
                        schema:
                            $ref: "models.yaml#/components/schemas/ServiceStatus"

""".data(using: .utf8)!

    static var responseWithRefOnResponseWillBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          responses:
            "200":
              $ref: "models.yaml#/components/responses/ServiceStatus"

""".data(using: .utf8)!

    static var responseWithRefWillBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          responses:
            "200":
                content:
                    application/json:
                        schema:
                            $ref: "models.yaml#/components/schemas/ServiceStatus"
""".data(using: .utf8)!


    static var responseWithDeclarationInSchemaWontBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          responses:
            "200":
                content:
                    application/json:
                        schema:
                            type: object
                            properties:
                                prop:
                                    type: string
""".data(using: .utf8)!

    static var responseWithoutContentWillBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          responses:
            "200":
              description: "Все ок"
""".data(using: .utf8)!

    static var responseSeparatedResponseWithSchemaDeclarationWontBeParsed = """
    paths:
      /messages:
        get:
          summary: Список сообщений пользователя. Тут приходят полные сообщения (вместе с детальным представлением)
          responses:
            "200":
              $ref: "models.yaml#/components/responses/Plain"
""".data(using: .utf8)!

    static var components = """
    components:

        requestBodies:
            ServiceStatus:
                content:
                    "application/json":
                        schema:
                            $ref: "models.yaml#/components/schemas/ServiceStatus"

        responses:
            ServiceStatus:
                content:
                    "application/json":
                        schema:
                            $ref: "models.yaml#/components/schemas/ServiceStatus"

            Plain:
                content:
                    "application/json":
                        schema:
                            type: object
                            properties:
                                prop:
                                    type: string

        parameters:
            Param:
              name: id
              required: true
              in: query
              schema:
                $ref: "#/components/schemas/ServiceStatus"

        schemas:
            ServiceStatus:
              type: string
              description: Статус услуги

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
""".data(using: .utf8)!
}
