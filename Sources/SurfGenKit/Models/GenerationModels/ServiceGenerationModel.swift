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
    let operations: [OperationGenerationModel]

    init(name: String, keys: [CodingKey], operations: [OperationGenerationModel]) {
        self.name = name
        self.hasKeys = !keys.isEmpty
        self.keys = keys
        self.operations = operations
    }

    var protocolName: String {
        return name + "Service"
    }

    var serviceName: String {
        return name + "NetworkService"
    }
    
}
