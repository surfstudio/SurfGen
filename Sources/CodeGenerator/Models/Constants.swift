//
//  Constants.swift
//  
//
//  Created by Александр Кравченков on 05.01.2021.
//

import Foundation

/// Some constants for models
enum Constants {
    /// String representation of primitive type
    ///
    /// Used in serialization to JSON
    static let primitiveTypeName = "primitive"

    /// String representation of referenced type
    ///
    /// Used in serialization to JSON
    static let referenceTypeName = "reference"

    /// String representation of array type
    ///
    /// Used in serialization to JSON
    static let arrayTypeName = "array"

    /// String representation of object type
    ///
    /// Used in serialization to JSON
    static let objectTypeName = "object"

    /// String representation of group type
    /// 
    /// Used in serialization to JSON
    static let groupTypeName = "group"

    /// String representation of enum type
    ///
    /// Used in serialization to JSON
    static let enumTypeName = "enum"

    /// String representation of alias type
    /// 
    /// Used in serialization to JSON
    static let aliasTypeName = "alias"
}
