//
//  GenerationError.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 09/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public enum GeneratorError: Error, Equatable {
    /// indicates that input ASTNode is not supposed to be used in particular generator
    case incorrectNodeToken(String)
    /// indicates that input node is not configured appropriately for code generator
    case nodeConfiguration(String)
    //// indicates that input node is node configured appropriately for node with contained token
    case incorrectNodeNumber(String)

    public static func ==(lhs: GeneratorError, rhs: GeneratorError) -> Bool {
        switch (lhs, rhs) {
        case (.incorrectNodeToken, .incorrectNodeToken),
             (.nodeConfiguration, .nodeConfiguration),
             (.incorrectNodeNumber, .incorrectNodeNumber):
            return true
        default:
            return false
        }
    }
}

public enum ConfiguarionError: Error {
    case cantFindBundle(String)
}
