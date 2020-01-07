//
//  DataType.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 07/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import SwiftyJSON

public indirect enum DataType {
    case array(DataType)
    case object
    case primitive(String)
    case ref(String)
}

extension DataType {

    public init?(json: JSON) {
        // implicit array
        if json["items"].dictionary != nil, let subType = DataType(json: json["items"]) {
            self = .array(subType)
            return
        }
        // implicit inline object
        if json.properties != nil {
            self = .object
            return
        }

        // explicit ref
        if let ref = json.refModel {
            self = .ref(ref)
            return
        }

        if let type = json.type {
            self = .primitive(type)
        }

        return nil

    }

}


public enum GroupType: String {
    case allOf
    case oneOf
    case anyOf
}

enum YamlToken {
    case root
    case decl(String)
    case group(String)
    case property(String, Bool)
    case type(DataType)
    case ref(String)
}

protocol YamlNode: class {
    var token: YamlToken { get }
    var subNodes: [YamlNode] { get }
}

 class Node: YamlNode {

    public var token: YamlToken
    public var subNodes: [YamlNode]

    public init(token: YamlToken, _ subNodes: [YamlNode]) {
        self.token = token
        self.subNodes = subNodes
    }

}
