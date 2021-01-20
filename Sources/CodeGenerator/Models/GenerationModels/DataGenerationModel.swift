//
//  DataGenerationModel.swift
//  
//
//  Created by Dmitry Demyanov on 19.01.2021.
//

import Foundation

public struct DataGenerationModel: Encodable {
    public let encoding: String
    public let typeName: String
    public let isTypeArray: Bool

    init(dataModel: DataModel) {
        encoding = dataModel.mediaType
        typeName = dataModel.typeName
        isTypeArray = dataModel.type.isArray
    }
}
