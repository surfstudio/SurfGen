//
//  ArrayExtension.swift
//  SurfGenKit
//
//  Created by Mikhail Monakov on 18/03/2020.
//

extension Array {

    func removingFirst() -> [Element] {
        var newArray = self
        newArray.removeFirst()
        return newArray
    }

}

extension Array where Element: Hashable {

    func uniqueElements() -> [Element] {
        return Array(Set(self))
    }

}

extension Array where Element == ASTNode {

    var contentNode: ASTNode? {
        guard let index = indexOf(.content) else {
            return nil
        }
        return self[index]
    }

    var encodingNode: ASTNode? {
        guard let index = indexOf(.encoding(type: "")) else {
            return nil
        }
        return self[index]
    }

    var declNode: ASTNode? {
        guard let index = indexOf(.decl) else {
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

    var locationNode: ASTNode? {
        guard let index = indexOf(.location(type: "")) else {
            return nil
        }
        return self[index]
    }

    var nameNode: ASTNode? {
        guard let index = indexOf(.name(value: "")) else {
            return nil
        }
        return self[index]
    }

    var pathNode: ASTNode? {
        guard let index = indexOf(.path(value: "")) else {
            return nil
        }
        return self[index]
    }

    var parametersNode: ASTNode? {
        guard let index = indexOf(.parameters) else {
            return nil
        }
        return self[index]
    }

    var requestBodyNode: ASTNode? {
        guard let index = indexOf(.requestBody(isOptional: Bool())) else {
            return nil
        }
        return self[index]
    }

    var responseBodyNode: ASTNode? {
        guard let index = indexOf(.responseBody) else {
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

    func indexOf(_ token: ASTToken) -> Int? {
        return firstIndex { $0.token == token }
    }

}
