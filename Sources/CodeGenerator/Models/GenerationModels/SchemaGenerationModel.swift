//
//  SchemaGenerationModel.swift
//  
//
//  Created by Dmitry Demyanov on 14.01.2021.
//

import Foundation

/// Describes a model (enum, typealias or object) which can be generated with an appropriate template
public enum SchemaGenerationModel {
    case `enum`(SchemaEnumModel)
    case object(SchemaObjectModel)
    case `typealias`(PrimitiveTypeAliasModel)

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

    public var containedTypealias: PrimitiveTypeAliasModel? {
        if case let .typealias(typeAliasModel) = self {
            return typeAliasModel
        }
        return nil
    }

    var name: String {
        switch self {
        case .enum(let enumModel):
            return enumModel.name
        case .object(let objectModel):
            return objectModel.name
        case .typealias(let typeAliasModel):
            return typeAliasModel.name
        }
    }
}

extension SchemaGenerationModel: Hashable {

    public func hash(into hasher: inout Hasher) {
        return hasher.combine(name)
    }

    public static func == (lhs: SchemaGenerationModel, rhs: SchemaGenerationModel) -> Bool {
        switch (lhs, rhs) {
        case (.enum, .enum),
             (.object, .object),
             (.typealias, .typealias):
            return lhs.name == rhs.name
        default:
            return false
        }
    }
}
