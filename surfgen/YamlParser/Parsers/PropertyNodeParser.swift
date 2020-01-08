//
//  PropertyNodeParser.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 08/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import SwiftyJSON

enum PropertyNodesParserError: Error {
    case noPropertiesFieldInProvidedJSON
}

final class PropertyNodesParser {

    func parse(for json: JSON) throws -> [YamlNode] {
        guard let properties = json.properties else {
            throw PropertyNodesParserError.noPropertiesFieldInProvidedJSON
        }
        let required = json.requiredArray
        var propertyNodes = [YamlNode]()
        for (name, value) in properties {
            guard let type = DataType(json: value) else { continue }
            let isOptional = value.nullable || !required.contains(name)
            propertyNodes.append(Node(token: .property(name: name, isOptional: isOptional), [Node(token: .type(type), [])]))
        }
        return propertyNodes
    }

}
