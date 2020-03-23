//
//  EnumGenerator.swift
//  SurfGenKit
//
//  Created by Mikhail Monakov on 18/03/2020.
//

import Stencil

final class EnumGenerator: ModelGeneratable {

    func generateCode(declNode: ASTNode, environment: Environment) throws -> FileModel {
        let declModel = try DeclNodeParser().getInfo(from: declNode)

        guard let typeNode = declNode.subNodes.typeNode else {
            throw GeneratorError.nodeConfiguration("decl node does not contain type")
        }
        let type = try TypeNodeParser().detectType(for: typeNode)

        let cases: [String] = declModel.fields.compactMap {
            if case let .value(value) = $0.token {
                return type.enumType == "String" ? "\"\(value)\"" : value
            }
            return nil
        }
        let enumModel = EnumGenerationModel(enumName: declModel.name,
                                            enumType: type.enumType ?? "",
                                            cases: cases,
                                            description: declModel.description)
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
