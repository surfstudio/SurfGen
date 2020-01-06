//
//  JSONExtension.swift
//  surfgen
//
//  Created by Mikhail Monakov on 06/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import SwiftyJSON

extension JSON {

    var properties: [String: JSON]? {
        return self["properties"].dictionary
    }

    var refModel: String? {
        return self["$ref"].string?.valueFromUrl
    }

    var schemas: JSON {
        return self["components"]["schemas"]
    }

    var allOf: [String: JSON]? {
        return self["allOf"].dictionary
    }

    var oneOf: [String: JSON]? {
        return self["oneOff"].dictionary
    }

    var type: String? {
        return self["type"].string
    }

}
