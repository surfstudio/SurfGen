//
//  GroupNodeParser.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 08/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import SwiftyJSON

enum GroupParserError: Error {
    case incorrectGroupConfiguraonJSON
}

final class GroupNodeParser {

    func parse(for json: JSON) throws -> [YamlNode] {
        guard let groupContent = json.array else {
            throw GroupParserError.incorrectGroupConfiguraonJSON
        }

        var nodes = [YamlNode]()

        for element in groupContent {
            if let ref = element.refModel {
                nodes.append(Node(token: .ref(ref), []))
                continue
            }

            if element.properties != nil {
                nodes.append(contentsOf: try PropertyNodesParser().parse(for: element))
                continue
            }
        }

        return nodes
    }

}
