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

    public func generateModel(from node: ASTNode, types: [ModelType], generateDescriptions: Bool = true) throws -> ModelGenerationModel {
        guard case .root = node.token else {
            throw GeneratorError.incorrectNodeToken("Root generator coundn't parse input node as node with root token")
        }

        let root = generateDescriptions ? node : node.filterAllDescriptions()
        let (objectDecls, enumDecls) = DeclNodeSplitter().split(nodes: root.subNodes)

        var model: ModelGenerationModel = [:]
        try types.forEach { try generate(for: $0, to: &model, from: $0 == .enum ? enumDecls : objectDecls) }
        return model
    }

    public func generateService(from node: ASTNode, generateDescriptions: Bool = true) throws -> ServiceGenerationModel {
        guard
            case .root = node.token,
            let declNode = node.subNodes.declNode
        else {
            throw GeneratorError.incorrectNodeToken("Root generator coundn't parse input node as service root node")
        }

        if !generateDescriptions {
            _ = node.filterAllDescriptions()
        }

        var serviceModel: ServiceGenerationModel = [:]
        try generate(part: .urlRoute, to: &serviceModel, from: declNode)
        return serviceModel
    }

    private func generate(for type: ModelType, to model: inout ModelGenerationModel, from nodes: [ASTNode]) throws {
        let generator = type.generator
        model[type] = try nodes.map { try generator.generateCode(declNode: $0, environment: environment) }
    }

    private func generate(part: ServicePart, to model: inout ServiceGenerationModel, from node: ASTNode) throws {
        let generator = part.generator
        model[part] = try generator.generateCode(declNode: node, environment: environment)
    }

}

private extension ModelType {

    var generator: CodeGenerator {
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

private extension ServicePart {

    var generator: CodeGenerator {
        switch self {
        case .urlRoute:
            return UrlRouteGenerator()
        case .protocol:
            // TODO: write generator
            return UrlRouteGenerator()
        case .service:
            // TODO: write generator
            return UrlRouteGenerator()
        }
    }
    
}
