//
//  ModelsType.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 09/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public enum ModelType {
    case entity
    case entry
    case `enum`

    var name: String {
        switch self {
        case .entity:
            return "Entity"
        case .entry:
            return "Entry"
        case .enum:
            return ""
        }
    }

    func form(name value: String) -> String {
        return "\(value)\(name)"
    }

}
