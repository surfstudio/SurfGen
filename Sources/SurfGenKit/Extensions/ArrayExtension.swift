//
//  ArrayExtension.swift
//  SurfGenKit
//
//  Created by Mikhail Monakov on 18/03/2020.
//

extension Array where Element == ASTNode {

    var nameNode: ASTNode? {
        guard let index = indexOf(.name(value: "")) else {
            return nil
        }
        return self[index]
    }

    var typeNode: ASTNode? {
        guard let index = indexOf(.type(name: "")) else {
            return nil
        }
        return self[index]
    }

    var descriptionNode: ASTNode? {
        guard let index = indexOf(.description("")) else {
            return nil
        }
        return self[index]
    }

    func indexOf(_ token: ASTToken) -> Int? {
        return firstIndex { $0.token == token }
    }

}
