//
//  GenerationError.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 09/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public enum GeneratorError: Error {
    /// indicates that input ASTNode is not supposed to be used in particular generator
    case incorrectNodeToken(String)
    /// indicates that input node is not configured appropriately for code generator
    case nodeConfiguration(String)
}

public enum ConfiguarionError: Error {
    case cantFindBundle(String)
}
