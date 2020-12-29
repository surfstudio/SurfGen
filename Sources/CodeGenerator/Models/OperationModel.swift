//
//  OperationModel.swift
//  
//
//  Created by Александр Кравченков on 17.12.2020.
//

import Foundation
import GASTTree

/// Data whic is used in `RequestModel` and `ResponseModel`
public struct DataModel {

    public enum Possible {
        case object(SchemaObjectModel)
        case array(SchemaArrayModel)
    }

    public let mediaType: String
    public let referencedValue: Possible

    public init(mediaType: String, referencedValue: Possible) {
        self.mediaType = mediaType
        self.referencedValue = referencedValue
    }
}

extension DataModel.Possible: Encodable {

    enum Keys: String, CodingKey {
        case type = "string"
        case value = "value"
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)

        switch self {
        case .object(let val):
            try container.encode("object", forKey: .type)
            try container.encode(val, forKey: .value)
        case .array(let val):
            try container.encode("array", forKey: .type)
            try container.encode(val, forKey: .value)
        }
    }
}

extension DataModel: Encodable { }

public struct RequestModel {
    public let description: String?
    public let content: [DataModel]
    public let isRequired: Bool
}

extension RequestModel: Encodable { }

public struct ResponseModel {
    /// May be statusCode or `default` string
    public let key: String
    public let values: [DataModel]
}

extension ResponseModel: Encodable { }

public struct OperationModel {
    public let httpMethod: String
    public let description: String?
    public let parameters: [Reference<ParameterModel>]?
    public let responses: [Reference<ResponseModel>]?
    public let requestModel: Reference<RequestModel>?
}

extension OperationModel: Encodable { }

