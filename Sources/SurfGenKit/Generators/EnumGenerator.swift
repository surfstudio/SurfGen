//
//  EnumGenerator.swift
//  SurfGenKit
//
//  Created by Mikhail Monakov on 18/03/2020.
//

import Stencil

final class EnumGenerator: CodeGenerator {

    private let platform: Platform

    init(platform: Platform) {
        self.platform = platform
    }

    func generateCode(for declNode: ASTNode, environment: Environment) throws -> FileModel {
        let declModel = try wrap(ModelDeclNodeParser().getInfo(from: declNode),
                                 with: "Could not generate num code")

        guard let typeNode = declNode.subNodes.typeNode else {
            throw SurfGenError(nested: GeneratorError.nodeConfiguration("decl node does not contain type"),
                               message: "Could not parse decl node")
        }
        let type = try wrap(TypeNodeParser(platform: platform).detectType(for: typeNode),
                            with: "Could not generate num code")

        let cases: [EnumCase] = declModel.fields.compactMap {
            guard case let .value(value) = $0.token else {
                return nil
            }
            if type.enumType == platform.plainType(type: .string) {
                return EnumCase(name: platform.constant(name: value),
                                camelCaseName: value.snakeCaseToCamelCase().capitalizingFirstLetter(),
                                value: "\"\(value)\"")
            } else {
                return EnumCase(name: nil, camelCaseName: nil, value: value)
            }
        }
        let enumModel = EnumGenerationModel(enumName: declModel.name,
                                            enumType: type.enumType ?? "",
                                            cases: cases,
                                            description: declModel.description ?? "")
        let code = try environment.renderTemplate(.enum(enumModel),
                                                  from: ModelType.enum.templateName)

        return .init(fileName: declModel.name.withFileExtension(platform.fileExtension),
                     code: code.trimmingCharacters(in: .whitespacesAndNewlines))
    }

}

private extension Type {

    var enumType: String? {
        guard case let .enum(type) = self else { return nil }
        return type
    }

}
