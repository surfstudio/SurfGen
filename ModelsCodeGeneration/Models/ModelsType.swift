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
    
    var name: String {
        switch self {
        case .entity:
            return "Entity"
        case .entry:
            return "Entry"
        }
    }

    func formName(with value: String) -> String {
        return "\(value)\(name)"
    }

}
