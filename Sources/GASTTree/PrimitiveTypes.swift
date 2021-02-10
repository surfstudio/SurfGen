//
//  PrimitiveTypes.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation

public enum PrimitiveType: String {
    case integer = "integer"
    case number = "number"
    case string = "string"
    case boolean = "boolean"
}

extension PrimitiveType: Encodable { }
