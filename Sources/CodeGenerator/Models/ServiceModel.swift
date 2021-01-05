//
//  File.swift
//  
//
//  Created by Александр Кравченков on 17.12.2020.
//

import Foundation

public struct ServiceModel {
    public let path: String
    public let operations: [OperationModel]
}

extension ServiceModel: Encodable { }
