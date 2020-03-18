//
//  ModelGeneratable.swift
//  SurfGenKit
//
//  Created by Mikhail Monakov on 18/03/2020.
//

import Stencil

public protocol ModelGeneratable {
    func generateCode(declNode: ASTNode, environment: Environment) throws -> (String, String)
}
