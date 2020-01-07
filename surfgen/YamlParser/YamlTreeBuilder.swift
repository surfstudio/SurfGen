//
//  YamlTreeBuilder.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 07/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import SwiftyJSON

final class YamlTreeBuilder {

    func buildTree(from schemas: JSON, models: [String]) -> YamlNode {
        var declNodes = [Node]()
        for model in models {
            guard let decl = schemas[model].dictionary else { continue }
            declNodes.append(Node(token: .decl(model), resolveDeclSubNodes(for: schemas[model])))
        }
        return Node(token: .root, [])
    }

    func resolveDeclSubNodes(for json: JSON) -> [YamlNode] {
        if let ref = json.refModel {
            return [Node(token: .ref(ref), [])]
        }

        if let allOf = json.allOf {
            return [Node(token: .group("allOf"), resolveGroup(for: json["allOf"]))]
        }

        if let properties = json.properties {
            var tmp = [YamlNode]()
            for (name, value) in properties {
                guard let type = DataType(json: value) else { continue }
                tmp.append(Node(token: .property(name, false), []))
            }
        }

        return []
    }

    func resolveGroup(for json: JSON) -> [YamlNode] {
        return []
    }

}

