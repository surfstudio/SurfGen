//
//  RootGenerator.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 09/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import Stencil

public final class RootGenerator {
    
    // MARK: - Private Properties

    private let environment: Environment
    
    // MARK: - Initialization

    public init() {
        environment = Environment(loader: FileSystemLoader(bundle: [Bundle(for: type(of: self))]))
    }

    /// for now this generator is supposed to generate code for complete AST
    public func generateCode(for node: ASTNode, type: ModelType) throws -> [(String, String)] {
        guard  case .root = node.token else {
            throw GeneratorError.incorrectNodeToken("Root generator coundn't parse input node as node with root token")
        }
        
        let generator: ModelGeneratable
        switch type {
        case .entry:
            generator = EntryGenerator()
        case .entity:
            generator = EntityGenerator()
        }
        
        var models = [(String, String)]()
        for decl in node.subNodes {
            models.append(try generator.generateCode(declNode: decl, environment: environment))
        }
        return models
    }

}
