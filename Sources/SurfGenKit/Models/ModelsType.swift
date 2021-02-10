//
//  ModelsType.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 09/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public enum ModelType: String {
    case entity
    case entry
    case `enum`

    private func getName(for platform: Platform) -> String {
        switch self {
        case .entity:
            return platform.entitySuffix
        case .entry:
            return platform.entrySuffix
        case .enum:
            return ""
        }
    }

    func form(name value: String, for platform: Platform) -> String {
        return "\(value)\(getName(for: platform))"
    }

}
