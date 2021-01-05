//
//  File.swift
//  
//
//  Created by Александр Кравченков on 28.12.2020.
//

import Foundation


enum ResolverYamls {

    enum FalsePositiveReferenceCycle {
        static var catalogModels = """
        components:
          schemas:
            ServiceStatus:
              type: string
              enum: [active, inactive, blocked]
              description: Статус услуги

            SubscriptionInfo:
              type: object
              description: Дополнительная информация по активной услуге
              properties:
                startDate:
                  $ref: "../common/aliases.yaml#/components/schemas/ISO8601Date"
                endDate:
                  $ref: "../common/aliases.yaml#/components/schemas/ISO8601Date"
                remainingDays:
                  type: number
                  description: Остаток дней
                currentTariffId:
                  type: string
                  example: OFF1059
                  description: ID тарифа (ID предложения)
                otherBalance:
                  type: string
                  description: Информация об активированных целевых картах оплаты
                extraDays:
                  type: string
                  description: Количество дней услуги в очереди

            Service:
              type: object
              description: Детальная информация по услуге
              properties:
                serviceId:
                  type: string
                  example: 121
                name:
                  type: string
                  example: Единый Ultra HD
                status:
                  $ref: "models.yaml#/components/schemas/ServiceStatus"
                iconUrl:
                  type: string
                prolongable:
                  type: string
                  description: Признак возможности продления услуги
                description:
                  type: string
                  description: Подробнее об услуге
                subscriptionInfo:
                  $ref: "models.yaml#/components/schemas/SubscriptionInfo"
                  description: Дополнительная информация, если услуга активна
    """.data(using: .utf8)!

        static var commonAliases = """
        components:
          schemas:

            ISO8601Date:
              description: Дата в формате ISO8601 `YYYY-MM-DDThh:mm:ss±hh:mm`
              type: string
        """.data(using: .utf8)!

        static var catalogApi = """

        paths:
          /billings/service?serviceId={serviceId}:
              get:
                summary: Детальная информация по услуге
                parameters:
                  - name: serviceId
                    required: true
                    in: query
                    schema:
                      type: string
                    description: ID услуги
                responses:
                  "200":
                    description: "Все ок"
                    content:
                      application/json:
                        schema:
                          $ref: "models.yaml#/components/schemas/Service"

        """.data(using: .utf8)!
    }
}
