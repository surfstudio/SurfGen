//
//  ItemTypeModel.swift
//  
//
//  Created by Дмитрий Демьянов on 23.02.2021.
//

import Foundation

/// Keeps type name of parameter, property or other structure if needed with additional info about type
public struct ItemTypeModel: Encodable {

    public let name: String

    public let isArray: Bool

    /// True if type is a ref to model or array with ref to model
    public let isObject: Bool

    /// If type is enum, this is enum's primitive type name
    public let enumTypeName: String?

    /// If type is alias of primitive type, this is the real primitive type name
    public let aliasTypeName: String?

    public init(name: String, isArray: Bool, isObject: Bool, enumTypeName: String?, aliasTypeName: String?) {
        self.name = name
        self.isArray = isArray
        self.isObject = isObject
        self.enumTypeName = enumTypeName
        self.aliasTypeName = aliasTypeName
    }

}
