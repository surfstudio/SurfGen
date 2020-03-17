//
//  RootGenerator.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 09/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import Stencil
import PathKit
import Foundation

public final class RootGenerator {

    // MARK: - Typealiases

    public typealias GenerationModel = [ModelType: [(fileName: String, code: String)]]

    // MARK: - Private Properties

    private let environment: Environment
    
    // MARK: - Initialization

    public init() {
        let bundle = Bundle(for: type(of: self))
        environment = Environment(loader: FileSystemLoader(bundle: [Bundle(path: bundle.bundlePath + "/Resources/Templates.bundle") ?? bundle]))
    }

    public init(tempatesPath: Path) {
        let loader = FileSystemLoader(paths: [tempatesPath])
        environment = Environment(loader: loader)
    }

//    /// for now this generator is supposed to generate code for complete AST
//    public func generateCode(for node: ASTNode, types: ModelType) throws -> [(String, String)] {
//        let generator: ModelGeneratable
//        switch type {
//        case .entry:
//            generator = EntryGenerator()
//        case .entity:
//            generator = EntityGenerator()
//        }
//
//        return try node.subNodes.map { try generator.generateCode(declNode: $0, environment: environment) }
//    }

    public func generateCode(for node: ASTNode, types: [ModelType]) throws -> GenerationModel {
        guard case .root = node.token else {
            throw GeneratorError.incorrectNodeToken("Root generator coundn't parse input node as node with root token")
        }

        let (objectDecls, enumDecls) = DeclNodeSplitter().split(nodes: node.subNodes)

        var model: GenerationModel = [:]
        for type in types {

        }
    }

}

final class DeclNodeSplitter {

    func split(nodes: [ASTNode]) -> (objectDecls: [ASTNode], enumDecls: [ASTNode]) {
        var objectDecls: [ASTNode] = []
        var enumDecls: [ASTNode] = []

        for node in nodes {
            guard node.subNodes.contains(where: {
                guard case let .type(name) = $0.token else {
                    return false
                }
                return name == "enum"
            }) else {
                objectDecls.append(node)
                continue
            }
            enumDecls.append(node)
        }

        return (objectDecls, enumDecls)
    }

}

private extension ModelType {

    var gererator: ModelGeneratable {
        switch self {
        case .entry:
            return EntryGenerator()
        case .entity:
            return EntityGenerator()
        case .enum:
            return EnumGenerator()
        }
    }

}

final class EnumGenerator: ModelGeneratable {

}
