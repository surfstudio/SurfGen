//
//  SchemaGenerationModel.swift
//  
//
//  Created by Dmitry Demyanov on 14.01.2021.
//

import Foundation

public enum SchemaGenerationModel {
    case `enum`(SchemaEnumModel)
    case object(SchemaObjectModel)
}

extension SchemaGenerationModel: Hashable {

    public func hash(into hasher: inout Hasher) {
        switch self {
        case .enum(let enumModel):
            hasher.combine(enumModel.name)
        case .object(let objectModel):
            hasher.combine(objectModel.name)
        }
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
