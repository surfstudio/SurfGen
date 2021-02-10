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

    static var tranditiveDepA = """
          application/json:
            schema:
              oneOf:
                - $ref: "modelsB.yaml#/components/schemas/AuthRequest"
""".data(using: .utf8)!

    static var tranditiveDepB = """
          application/json:
            schema:
              oneOf:
                - $ref: "modelsC.yaml#/components/schemas/AuthRequest"
""".data(using: .utf8)!

    static var tranditiveDepC = """
          application/json:
            schema:
              oneOf:
                - $ref: "modelsA.yaml#/components/schemas/AuthRequest"
""".data(using: .utf8)!

    static var sameNormalizedPathes = """
          application/json:
            schema:
              oneOf:
                - $ref: "./a/b/modelsA.yaml#/components/schemas/AuthRequest"
                - $ref: "./a/b/c/../modelsA.yaml#/components/schemas/AuthRequest"
""".data(using: .utf8)!
}

extension SpecFilesDeclaration {

    enum BugWithDoublingDependencies {
        public static let api = """
          application/json:
            schema:
              oneOf:
                - $ref: "../billings/models.yaml#/components/schemas/Tariffs"
""".data(using: .utf8)!

        public static var models = """
          application/json:
            schema:
              oneOf:
                - $ref: "models.yaml#/components/schemas/ServiceStatus"
                - $ref: "../billings/models.yaml#/components/schemas/TariffInfo"
                - $ref: "../common/aliases.yaml#/components/schemas/ISO8601Date"
                - $ref: "../common/aliases.yaml#/components/schemas/ISO8601Date"
                - $ref: "../common/aliases.yaml#/components/schemas/ISO8601Date"
                - $ref: "../billings/models.yaml#/components/schemas/TariffInfo"
                - $ref: "models.yaml#/components/schemas/ServiceStatus"
                - $ref: "models.yaml#/components/schemas/SubscriptionInfo"
""".data(using: .utf8)!

        public static var commonModels = """
        components:
          schemas:

            InfoMessage:
              type: object
              description: Модель, которая хранит какое-то сообщение
              properties:
                text:
                  type: string
                  nullable: false

            OtpRequired:
              type: object
              description: Модель, которая приходит, если нужен ОТП
              properties:
                nextOtp:
                  type: number
                  description: время возможной отправки следующего кода. В секундах
                  example: 60
              required:
                - nextOtp

            # OtpAndInfo:
            #   oneOf:
            #     - $ref: "../common/models.yaml#/components/schemas/OtpRequired"
            #     - $ref: "../common/models.yaml#/components/schemas/InfoMessage"

            KeyValuePair:
              type: object
              description: Пара ключ-значение
              properties:
                key:
                  type: string
                value:
                  type: string
              required:
                - key
                - value

""".data(using: .utf8)!

        public static var commonAliases = """
        components:
          schemas:

            ISO8601Date:
              description: Дата в формате ISO8601 `YYYY-MM-DDThh:mm:ss±hh:mm`
              type: string
""".data(using: .utf8)!

        public static var billingsModels = """
          application/json:
            schema:
              oneOf:
                - $ref: "models.yaml#/components/schemas/TariffInfo"
                - $ref: "models.yaml#/components/schemas/Tariffs"
                - $ref: "models.yaml#/components/schemas/MobileType"
                - $ref: "../common/aliases.yaml#/components/schemas/ISO8601Date"
                - $ref: "models.yaml#/components/schemas/PaySystemCodeForMobile"
                - $ref: "models.yaml#/components/schemas/FirstScreenInfo"
                - $ref: "models.yaml#/components/schemas/ContactInfo"
                - $ref: "models.yaml#/components/schemas/ContactInfo"
                - $ref: "models.yaml#/components/schemas/ParameterItem"
                - $ref: "models.yaml#/components/schemas/ItemForPayment"
                - $ref: "../common/models.yaml#/components/schemas/KeyValuePair"
""".data(using: .utf8)!

        public static var commonErrors = """
          application/json:
            schema:
              oneOf:
                - $ref: "#/components/schemas/CommonError"
""".data(using: .utf8)!
    }
}
