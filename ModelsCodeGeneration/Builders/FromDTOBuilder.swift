//
//  FromDTOBuilder.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 24/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public class FromDTOBuilder {

    func buildString(for type: Type, with name: String, isOptional: Bool) -> String {
        switch type {
        case .plain:
            return "model.\(name)"
        case .object:
            return ".from(dto: model.\(name))"
        case .array(let subType):
            switch subType {
            case .plain:
                return "model.\(name)"
            case .object:
                return "try model.\(name)\(isOptional.keyWord).map { try .from(dto: $0) }"
            case .array:
                return "not supported case"
            }
        }
    }

}
