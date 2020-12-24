//
//  ResponseBodyGenerationModel.swift
//  
//
//  Created by Dmitry Demyanov on 23.12.2020.
//

enum ResponseBody: Equatable {
    case model(String)
    case arrayOf(String)
    case empty
    case unsupportedObject
}

struct ResponseBodyGenerationModel {
    
    private(set) var isUndefined = false
    private(set) var isEmpty = false
    private(set) var isArray = false
    private(set) var model: String?
    
    init(response: ResponseBody) {
        switch response {
        case .model(let modelName):
            self.model = modelName
        case .arrayOf(let modelName):
            self.isArray = true
            self.model = modelName
        case .empty:
            self.isEmpty = true
        case .unsupportedObject:
            self.isUndefined = true
        }
    }
}
