//
//  YamlTreeBuilder.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 07/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import SwiftyJSON

final class YamlTreeBuilder {

    func buildTree(from schemas: JSON, models: [String]) throws -> YamlNode {
        var declNodes = [Node]()
        for model in models {
            guard schemas[model].dictionary != nil else { continue }
            declNodes.append(Node(token: .decl(model), try resolveDeclSubNodes(for: schemas[model])))
        }
        return Node(token: .root, declNodes)
    }

    func resolveDeclSubNodes(for json: JSON) throws -> [YamlNode] {
        // model subNode may be as simple ref to another object
        if let ref = json.refModel {
            return [Node(token: .ref(ref), [])]
        }

        // implicit object type
        if json.properties != nil {
            return try PropertyNodesParser().parse(for: json)
        }

        // in case if its not object and not ref and can be parsed as DataType then its "fake" object where type is array of any objects or its primitive type
        if json.type != nil, let type = DataType(json: json) {
            return [Node(token: .type(type), [])]
        }

        // the last possible option that it is group node
        if let group = json.dictionary?.first?.key {
            return [Node(token: .group(group), try GroupNodeParser().parse(for: json[group]))]
        }

        return []
    }

}
