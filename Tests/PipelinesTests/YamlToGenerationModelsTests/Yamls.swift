//
//  File.swift
//  
//
//  Created by Александр Кравченков on 19.12.2020.
//

import Foundation

extension ParametersTests {
    /// Contains service `messages` with one operation `get`
    /// And the operation contains two parameters `id1` and `id2` with `integer` and `string` types
    /// Each parameter is declared `in place`
    /// Contains one response with type `string`
    static var withPrimitiveTypeInPlaceWillBeParsed = """
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
}
