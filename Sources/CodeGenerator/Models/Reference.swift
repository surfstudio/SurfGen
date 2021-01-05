//
//  File.swift
//  
//
//  Created by Александр Кравченков on 17.12.2020.
//

import Foundation

public enum Reference<DataType> {
    case reference(DataType)
    case notReference(DataType)
}

extension Reference: Encodable where DataType: Encodable {

    enum CodingKeys: String, CodingKey {
        case isReference = "isReference"
        case value = "value"
    }

    var isReference: Bool {
        switch self {
        case .notReference:
            return false
        case .reference:
            return true
        }
    }

    var value: DataType {
        switch self {
        case .notReference(let val):
            return val
        case .reference(let val):
            return val
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.isReference, forKey: .isReference)
        try container.encode(self.value, forKey: CodingKeys.value)
    }

}
