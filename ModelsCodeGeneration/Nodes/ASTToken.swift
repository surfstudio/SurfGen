//
//  ASTToken.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 19/10/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public enum ASTToken {
    case name(value: String)
    case decl
    case content
    case field(isOptional: Bool)
    case type(name: String)
    case root
}

