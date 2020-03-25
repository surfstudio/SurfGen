//
//  ASTNodeExtenstion.swift
//  SurfGenKit
//
//  Created by Mikhail Monakov on 25/03/2020.
//

extension ASTNode {

    var description: String? {
        guard let descNode = subNodes.descriptionNode, case let .description(desc) = descNode.token else {
            return nil
        }
        return desc
    }

    func filterAllDescriptions() -> ASTNode {
        guard let node = self as? Node else {
            return self
        }
        var currentNodes: [Node] = [node]

        while !currentNodes.isEmpty {
            currentNodes.forEach { $0.subNodes.removeAll(where: { $0.token == .description("") }) }
            currentNodes = currentNodes.compactMap { $0.subNodes as? [Node] }.flatMap { $0 }
        }

        return self
    }

}
