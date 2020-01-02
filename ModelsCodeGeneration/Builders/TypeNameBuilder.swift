//
//  TypeNameBuilder.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 24/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public class TypeNameBuilder {

    /**
     Method for generating type description in code

     For type: .object(Profile), isOptional: true, modelType: .entity the result string will be "ProfileEntity?"
     Other exapmles of resulted string: [Int]?, Bool, [ProfileEntry]?
     */
    func buildString(for type: Type, isOptional: Bool, modelType: ModelType) -> String {
        switch type {
        case .plain(let value):
            return value.formOptional(isOptional)
        case .object(let value):
            return modelType.form(name: value).formOptional(isOptional)
        case .array(let subType):
            switch subType {
            case .plain(let value):
                return "[\(value)]".formOptional(isOptional)
            case .object(let value):
                return "[\(modelType.form(name: value))]".formOptional(isOptional)
            case .array:
                return "not supported case"
            }
        }
    }

}
