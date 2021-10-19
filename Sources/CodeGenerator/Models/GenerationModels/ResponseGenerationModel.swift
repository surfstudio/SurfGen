//
//  ResponseGenerationModel.swift
//  
//
//  Created by Александр Кравченков on 19.10.2021.
//

import Foundation

/// Container for different `DataGenerationModel` with the same `http status code` or other response key
public struct ResponseGenerationModel: Encodable {
    public let key: String
    public let responses: [DataGenerationModel]

    public init(key: String, responses: [DataGenerationModel]) {
        self.key = key
        self.responses = responses
    }
}
