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

    public func generateCode(for node: ASTNode, types: [ModelType], generateDescriptions: Bool) throws -> GenerationModel {
        guard case .root = node.token else {
            throw GeneratorError.incorrectNodeToken("Root generator coundn't parse input node as node with root token")
        }

        let root = generateDescriptions ? node : node.filterAllDescriptions()
        let (objectDecls, enumDecls) = DeclNodeSplitter().split(nodes: root.subNodes)

        var model: GenerationModel = [:]
        try types.forEach { try generate(for: $0, to: &model, from: $0 == .enum ? enumDecls : objectDecls) }
        return model
    }

    private func generate(for type: ModelType, to model: inout GenerationModel, from nodes: [ASTNode]) throws {
        let generator = type.gererator
        model[type] = try nodes.map { try generator.generateCode(declNode: $0, environment: environment) }
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
