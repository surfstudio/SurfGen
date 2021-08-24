//
//  OptionalsUseCaseYamls.swift
//  
//
//  Created by Александр Кравченков on 24.08.2021.
//

import Foundation

enum OptionalsUseCaseYamls {

    static let objectPath = """
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
                    $ref: "models.yaml#/components/schemas/Object"
""".data(using: .utf8)!
        

    static let schemaWithNullableTrue = """
    components:
        schemas:
            Object:
              type: object
              properties:
                item:
                  type: string
                  nullable: true
""".data(using: .utf8)!

    static let schemaWithNullableFalse = """
    components:
        schemas:
            Object:
              type: object
              properties:
                item:
                  type: string
                  nullable: false
""".data(using: .utf8)!

    static let schemaWithoutNullable = """
    components:
        schemas:
            Object:
              type: object
              properties:
                item:
                  type: string
""".data(using: .utf8)!
}
