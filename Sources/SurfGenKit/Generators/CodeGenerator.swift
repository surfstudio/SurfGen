//
//  ModelGeneratable.swift
//  SurfGenKit
//
//  Created by Mikhail Monakov on 18/03/2020.
//

import Stencil

public protocol CodeGenerator {
    func generateCode(for declNode: ASTNode, environment: Environment) throws -> FileModel
}
