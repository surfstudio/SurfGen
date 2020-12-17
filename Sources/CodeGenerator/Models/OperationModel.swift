//
//  OperationModel.swift
//  
//
//  Created by Александр Кравченков on 17.12.2020.
//

import Foundation
import GASTTree

public struct OperationModel {

    public let httpMethod: String
    public let description: String?
    public let parameters: [Reference<ParameterModel, ParameterModel>]?
    public let responseModel: SchemaModel?
    public let requestModel: SchemaModel?
}
