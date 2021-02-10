//
//  ServiceGenerationModel.swift
//  
//
//  Created by Dmitry Demyanov on 08.11.2020.
//

struct CodingKey {
    let name: String
    let serverName: String
}

struct ServiceGenerationModel {

    let name: String
    let hasKeys: Bool
    let keys: [CodingKey]
    let paths: [PathGenerationModel]
    let operations: [OperationGenerationModel]

    init(name: String, keys: [CodingKey], paths: [PathGenerationModel], operations: [OperationGenerationModel]) {
        self.name = name
        self.hasKeys = !keys.isEmpty
        self.keys = keys
        self.paths = paths
        self.operations = operations
    }
    
}
