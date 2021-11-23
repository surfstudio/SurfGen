//
//  DataGenerationModel.swift
//  
//
//  Created by Dmitry Demyanov on 19.01.2021.
//

import Foundation

public struct DataGenerationModel: Encodable {

    public let encoding: String
    public let typeNames: [String]
    public let isTypeArray: Bool
    public let isTypeObject: Bool
    public let isRequired: Bool

    init(dataModel: DataModel, isRequired: Bool = true) {
        self.encoding = dataModel.mediaType
        self.typeNames = dataModel.type.nameOptions
        self.isTypeArray = dataModel.type.isArray
        self.isTypeObject = dataModel.type.isObject
        self.isRequired = isRequired
    }
}
