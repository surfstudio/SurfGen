//
//  CodeGenerator.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 19/10/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import Foundation

public enum ModelType {
    case entity
    case entry
    
    var name: String {
        switch self {
        case .entity:
            return "Entity"
        case .entry:
            return "Entry"
        }
    }

}

public final class CodeGenerator {

    // максимально тестовый вариант как построить по дереву модель
    public func generateEntitiesCode(for root: ASTNode, type: ModelType) -> [String] {

        var files = [String]()
        let customTypes = formAllCustomTypes(for: root)

        for decl in root.next {
            var file = ""
            let declName = (decl.next.first(where: { $0 is NameNode }) as? NameNode)?.name ?? ""
            file.append("public struct \(declName)\(type.name) {\n")
            for field in decl.next[1].next {
                let fieldName = (field.next.first(where: { $0 is NameNode }) as? NameNode)?.name ?? ""
                let fieldType = (field.next.first(where: { $0 is TypeNode }) as? TypeNode)?.typeName ?? ""
                file.append("   public let \(fieldName): \(fieldType)\n")
            }
            file.append("}")
            files.append(file)
        }

        return files
    }

    // идея для проверки полей (ожидается, что в рамках дерева все типы либо встроенные, либо находятся в вернем слое decl)
    private func formAllCustomTypes(for root: ASTNode) -> [String] {
        return root.next.compactMap { decl in
            return (decl.next.first(where: { $0 is NameNode }) as? NameNode)?.name
        }
    }

}
