//
//  TypeNameBuilder.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 24/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public class TypeNameBuilder {

    private let platform: Platform

    init(platform: Platform) {
        self.platform = platform
    }

    /**
     Method for generating type description in code

     For type: .object(Profile), isOptional: true, modelType: .entity the result string will be "ProfileEntity"
     Other exapmles of resulted string: [Int], Bool, [ProfileEntry]
     */
    func buildString(for type: Type, modelType: ModelType) -> String {
        switch type {
        case .plain(let value):
            return value
        case .enum(let value):
            return value
        case .object(let value):
            return modelType.form(name: value, for: platform)
        case .array(let subType):
            switch subType {
            case .enum(let value):
                return value.asArray(platform: platform)
            case .plain(let value):
                return value.asArray(platform: platform)
            case .object(let value):
                return (modelType.form(name: value, for: platform)).asArray(platform: platform)
            case .array:
                return "not supported case"
            }
        }
    }

}
