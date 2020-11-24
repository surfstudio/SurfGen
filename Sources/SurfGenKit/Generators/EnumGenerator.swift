//
//  EnumGenerator.swift
//  SurfGenKit
//
//  Created by Mikhail Monakov on 18/03/2020.
//

import Stencil

final class EnumGenerator: CodeGenerator {

    func generateCode(for declNode: ASTNode, environment: Environment) throws -> FileModel {
        let declModel = try wrap(ModelDeclNodeParser().getInfo(from: declNode),
                                 with: "Could not generate num code")

        guard let typeNode = declNode.subNodes.typeNode else {
            throw SurfGenError(nested: GeneratorError.nodeConfiguration("decl node does not contain type"),
                               message: "Could not parse decl node")
        }
        let type = try wrap(TypeNodeParser().detectType(for: typeNode),
                            with: "Could not generate num code")

        let cases: [String] = declModel.fields.compactMap {
            if case let .value(value) = $0.token {
                return type.enumType == "String" ? "\"\(value)\"" : value
            }
            return nil
        }
        let enumModel = EnumGenerationModel(enumName: declModel.name,
                                            enumType: type.enumType ?? "",
                                            cases: cases,
                                            description: declModel.description ?? "")
        let code = try environment.renderTemplate(.enum(enumModel))

        return .init(fileName: declModel.name.withSwiftExt, code: code.trimmingCharacters(in: .whitespacesAndNewlines))
    }

}

private extension Type {

    var enumType: String? {
        guard case let .enum(type) = self else { return nil }
        return type
    }

}
