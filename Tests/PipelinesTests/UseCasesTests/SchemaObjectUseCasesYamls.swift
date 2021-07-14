//
//  File.swift
//  
//
//  Created by Александр Кравченков on 28.12.2020.
//

import Foundation

enum SchemaObjectUseCasesYamls {
    static var arrayCanBeParsed = """
    components:
        schemas:
            Array:
                type: array
                items:
                    type: integer
""".data(using: .utf8)!

    static var arrayInResponseDeclrationCanBeParsed = """
    paths:
      /billings/services:
        get:
          summary: Услуги для каталога
          responses:
            "200":
              description: "Все ок"
              content:
                application/json:
                  schema:
                    type: array
                    items:
                      type: integer
""".data(using: .utf8)!

    static var arrayInResponseWithRefs = """
    paths:
      /billings/services:
        get:
          summary: Услуги для каталога
          responses:
            "200":
              description: "Все ок"
              content:
                application/json:
                  schema:
                    type: array
                    items:
                      $ref: "models.yaml#/components/schemas/Alias"
            "201":
              description: "Все ок"
              content:
                application/json:
                  schema:
                    type: array
                    items:
                      $ref: "models.yaml#/components/schemas/Object"
            "202":
              description: "Все ок"
              content:
                application/json:
                  schema:
                    type: array
                    items:
                      $ref: "models.yaml#/components/schemas/Enum"
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

            Object:
                type: object
                properties:
                    field:
                        $ref: "#/components/schemas/Alias"

            Enum:
              type: string
              enum: ["1", "2", "3"]
              description: Статус услуги

            Alias:
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

    static var intEnum = """
    components:
        schemas:
            AlertsType:
                  type: integer
                  enum: [1,2,3]
                  description:  |
                    Тип передачи уведомления:
                    - 1 - выкл
                    - 2 - push
                    - 3 - sms
                  example: 3
""".data(using: .utf8)!
}
