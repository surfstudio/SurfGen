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
}
