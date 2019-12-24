//
//  ToDTOBuilder.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 24/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public class ToDTOBuilder {

    func buildString(for type: Type, with name: String, isOptional: Bool) -> String {
        switch type {
        case .plain:
            return name.snakeCaseToCamelCase()
        case .object:
            return "try \(name.snakeCaseToCamelCase())\(isOptional.keyWord).toDTO()"
        case .array(let subType):
            switch subType {
            case .plain:
                return name.snakeCaseToCamelCase()
            case .object:
                return "try \(name.snakeCaseToCamelCase())\(isOptional.keyWord).toDTO()"
            case .array:
                return "not supported case"
            }
        }
    }

}
