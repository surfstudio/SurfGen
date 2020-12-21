//
//  SchemaType.swift
//  
//
//  Created by Александр Кравченков on 18.12.2020.
//

import Foundation
import GASTTree

/// This is the enumeration of possible schema object
///
/// It's about entities that is written in `schemas:` part
/// In terms of this comments any items which is encluded in `schemas:` part is called `entity`
public enum SchemaType {
    /// Just a primitive type
    /// Schema which is primitive is just an alias
    ///
    /// For example:
    /// ```YAML
    ///schemas:
    ///     UserID:
    ///         type: string
    /// ```
    /// And `UserID` is just an alias on `String` type
    ///
    /// In Swift it would look like `typealias UserID = String`
    case primitive(PrimitiveType)
    /// It's an entity with `PrimitiveType` but it has property `enum`
    case `enum`(SchemaEnumModel)
    /// Entity which `type` property is `object`
    case object(SchemaObjectModel)
}
