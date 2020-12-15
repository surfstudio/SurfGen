//
//  File.swift
//  
//
//  Created by Александр Кравченков on 12.12.2020.
//

import Foundation

struct SpecFilesDeclaration {
    static var withOneFileRef = """
      responses:
        "200":
          description: "ok"
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: "models.yaml#/components/schemas/CatalogItem"
""".data(using: .utf8)!

    static var withoutRefs = """
    /billings/tariffs?serviceId={serviceId}:
        get:
          parameters:
            - name: serviceId
              required: true
              in: query
              schema:
                type: string
    """.data(using: .utf8)!

    static var withLocalRef = """
      responses:
        "200":
          description: "ok"
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: "/components/schemas/CatalogItem"
""".data(using: .utf8)!

    static var withTwoSameFileRef = """
      responses:
        "200":
          description: "ok"
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: "models.yaml#/components/schemas/CatalogItem"
      responses:
        "200":
          description: "ok"
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: "models.yaml#/components/schemas/CatalogItem"

""".data(using: .utf8)!

    static var withTwoDifferentFileRef = """
      responses:
        "200":
          description: "ok"
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: "models.yaml#/components/schemas/CatalogItem"
      responsesvar:
        "200":
          description: "ok"
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: "models2.yaml#/components/schemas/CatalogItem"

""".data(using: .utf8)!

    static var withArrayWithRefs = """
          application/json:
            schema:
              oneOf:
                - $ref: "models.yaml#/components/schemas/AuthRequest"
                - $ref: "models.yaml#/components/schemas/SilentAuthRequest"
""".data(using: .utf8)!
}
