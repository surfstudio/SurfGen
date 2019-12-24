//
//  TypeNameBuilder.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 24/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public class TypeNameBuilder {

    func buildString(for type: Type, isOptional: Bool, modelType: ModelType) -> String {
        switch type {
        case .plain(let value):
            return value.formOptional(isOptional)
        case .object(let value):
            return modelType.formName(with: value).formOptional(isOptional)
        case .array(let subType):
            switch subType {
            case .plain(let value):
                return "[\(value)]".formOptional(isOptional)
            case .object(let value):
                return "[\(modelType.formName(with: value))]".formOptional(isOptional)
            case .array:
                return "not supported case"
            }
        }
    }

}
