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

    static var components = """
    components:
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
