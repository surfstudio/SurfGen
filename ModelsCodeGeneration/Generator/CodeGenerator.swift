//
//  CodeGenerator.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 19/10/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public protocol CodeGeneratable {
    func generateCode(for node: ASTNode, type: ModelType) throws -> String
}


