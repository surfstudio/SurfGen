//
//  OperationNode.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation

public struct OperationNode {

    public struct ResponseBody {
        /// May be `200` or `default` etc.
        /// Fo more imformation look at https://swagger.io/specification/#responses-object
        public let key: String
        public let response: Referenced<ResponseNode>?

        public init(key: String, response: Referenced<ResponseNode>?) {
            self.key = key
            self.response = response
        }
    }

    public let method: String
    public let description: String?
    public let summary: String?
    public let parameters: [Referenced<ParameterNode>]
    public let requestBody: Referenced<RequestBodyNode>?
    public let responses: [ResponseBody]

    public init(method: String,
                description: String?,
                summary: String?,
                parameters: [Referenced<ParameterNode>],
                requestBody: Referenced<RequestBodyNode>?,
                responses: [ResponseBody]) {
        self.method = method
        self.description = description
        self.summary = summary
        self.parameters = parameters
        self.requestBody = requestBody
        self.responses = responses
    }
}
