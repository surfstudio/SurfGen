//
//  OpenAPIASTBuilderTestsYamls.swift
//  
//
//  Created by Александр Кравченков on 22.10.2021.
//

import Foundation

enum OpenAPIASTBuilderTestsYamls {
    static let modelA = """
    components:
        schemas:
            ModelA:
                type: array
                items:
                    type: integer
""".data(using: .utf8)!

    static let modelB = """
    components:
        schemas:
            ModelB:
                type: array
                items:
                    type: integer
""".data(using: .utf8)!

    static let modelC = """
    components:
        schemas:
            ModelC:
                type: array
                items:
                    type: integer
""".data(using: .utf8)!
}
