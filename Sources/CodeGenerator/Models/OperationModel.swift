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

public struct RequestModel {
    public let description: String?
    public let content: [DataModel]
    public let isRequired: Bool
}

public struct ResponseModel {
    /// May be statusCode or `default` string
    public let key: String
    public let values: [DataModel]
}

public struct OperationModel {
    public let httpMethod: String
    public let description: String?
    public let parameters: [Reference<ParameterModel, ParameterModel>]?
    public let responses: [Reference<ResponseModel, ResponseModel>]?
    public let requestModel: Reference<RequestModel, RequestModel>?
}
