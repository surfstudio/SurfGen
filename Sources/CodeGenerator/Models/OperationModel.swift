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
    public let mediaType: String
    public let referencedValue: SchemaObjectModel

    public init(mediaType: String, referencedValue: SchemaObjectModel) {
        self.mediaType = mediaType
        self.referencedValue = referencedValue
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

