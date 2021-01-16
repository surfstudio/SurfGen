//
//  SchemaGenerationModel.swift
//  
//
//  Created by Dmitry Demyanov on 14.01.2021.
//

import Foundation

/// Describes a model (enum or object) which can be generated with an appropriate template
public enum SchemaGenerationModel {
    case `enum`(SchemaEnumModel)
    case object(SchemaObjectModel)

    public var containedEnum: SchemaEnumModel? {
        if case let .enum(enumModel) = self {
            return enumModel
        }
        return nil
    }

    public var containedObject: SchemaObjectModel? {
        if case let .object(objectModel) = self {
            return objectModel
        }
        return nil
    }

    var name: String {
        switch self {
        case .enum(let enumModel):
            return enumModel.name
        case .object(let objectModel):
            return objectModel.name
        }
    }
}

extension SchemaGenerationModel: Hashable {

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(name)
    }

    public static func == (lhs: SchemaGenerationModel, rhs: SchemaGenerationModel) -> Bool {
        switch (lhs, rhs) {
        case (.enum(let leftEnum), .enum(let rightEnum)):
            return leftEnum.name == rightEnum.name
        case (.object(let leftObject), .object(let rightObject)):
            return leftObject.name == rightObject.name
        default:
            return false
        }
    }
}
