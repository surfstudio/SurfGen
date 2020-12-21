//
//  SchemaModel.swift
//  
//
//  Created by Александр Кравченков on 17.12.2020.
//

import Foundation

public struct SchemaObjectModel {
    public let name: String
    public let properties: [PropertyModel]
    public let description: String?
}
