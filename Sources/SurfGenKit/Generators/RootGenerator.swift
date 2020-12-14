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

    // MARK: - Public properties

    public var warningsLog: String {
        return WarningCollector.shared.reportLog
    }

    // MARK: - Private Properties

    private let environment: Environment
    private var platform: Platform
    private var serviceGenerator: ServiceGenerator?
    
    // MARK: - Initialization

    public init(platform: Platform) {
        let bundle = Bundle(for: type(of: self))
        environment = Environment(loader: FileSystemLoader(bundle: [Bundle(path: bundle.bundlePath + "/Resources/Templates.bundle") ?? bundle]))
        self.platform = platform
    }

    public init(tempatesPath: Path, platform: Platform) {
        let loader = FileSystemLoader(paths: [tempatesPath])
        environment = Environment(loader: loader)
        self.platform = platform
    }

    public func setServiceGenerator(_ generator: ServiceGenerator) {
        serviceGenerator = generator
    }

    public func generateModel(from node: ASTNode, types: [ModelType], generateDescriptions: Bool = true) throws -> ModelGeneratedModel {
        guard case .root = node.token else {
            throw SurfGenError(nested: GeneratorError.incorrectNodeToken("Root generator coundn't parse input node as node with root token"),
                               message: "Could not generate model")
        }

        let root = generateDescriptions ? node : node.filterAllDescriptions()
        let (objectDecls, enumDecls) = DeclNodeSplitter().split(nodes: root.subNodes)

        var model: ModelGeneratedModel = [:]
        try types.forEach { try generate(for: $0, to: &model, from: $0 == .enum ? enumDecls : objectDecls) }
        return model
    }

    public func generateService(name: String, from node: ASTNode, generateDescriptions: Bool = true) throws -> ServiceGeneratedModel {
        guard let generator = serviceGenerator else {
            fatalError("serviceGenerator not provided")
        }
        guard
            case .root = node.token,
            let declNode = node.subNodes.declNode
        else {
            throw SurfGenError(nested: GeneratorError.incorrectNodeToken("Root generator coundn't parse input node as service root node"),
                               message: "Could not generate service")
        }

        if !generateDescriptions {
            _ = node.filterAllDescriptions()
        }

        return try generator.generateCode(for: declNode, withServiceName: name, environment: environment)
    }

    private func generate(for type: ModelType, to model: inout ModelGeneratedModel, from nodes: [ASTNode]) throws {
        let generator = type.generator(for: platform)
        model[type] = try nodes.map { try generator.generateCode(for: $0, environment: environment) }
    }

}

private extension ModelType {

    func generator(for platform: Platform) -> CodeGenerator {
        switch self {
        case .entry:
            return EntryGenerator(platform: platform)
        case .entity:
            return EntityGenerator(platform: platform)
        case .enum:
            return EnumGenerator(platform: platform)
        }
    }

}
