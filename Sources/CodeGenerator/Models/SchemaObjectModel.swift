//
//  SchemaModel.swift
//  
//
//  Created by Александр Кравченков on 17.12.2020.
//

import Foundation

/// This data structure describes schema object.
/// In other words:
///
///```YAML
///components:
///     schemas:
///         AnyObject: <-- `name`
///             description: "description"  <-- `description`
///             type: object # <-- this is important
///             properties: <-- `properties`
///                 field1:
///                     type: string
///```
public struct SchemaObjectModel {
    public let name: String
    public let properties: [PropertyModel]
    public let description: String?

    public init(name: String, properties: [PropertyModel], description: String?) {
        self.name = name
        self.properties = properties
        self.description = description
    }
}
