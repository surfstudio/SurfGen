//
//  SwaggerCorrectorYamls.swift
//  
//
//  Created by Дмитрий Демьянов on 08.11.2021.
//

import Foundation

enum SwaggerCorrectorYamls {
    /// Contains service `messages` with one operation `get`
    /// Service has path parameter `id` with type `string`, it is declared in `Operation`
    static var yamlWithPathParametersInOperationWontBeParsed = """
    paths:
      /messages/{id}:
        get:
          parameters:
            - name: id
              required: true
              in: path
              schema:
                type: string
          responses:
            default:
                description: "Все ок"
                content:
                    application/json:
                        schema:
                            type: integer

""".data(using: .utf8)!
}
