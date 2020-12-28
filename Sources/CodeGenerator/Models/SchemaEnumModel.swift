//
//  File.swift
//  
//
//  Created by Александр Кравченков on 18.12.2020.
//

import Foundation
import GASTTree

public struct SchemaEnumModel {
    public let name: String
    public let cases: [String]
    public let type: PrimitiveType
}

extension SchemaEnumModel: Encodable { }
