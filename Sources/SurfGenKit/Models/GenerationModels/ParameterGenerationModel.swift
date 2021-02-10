//
//  ParameterGenerationModel.swift
//  
//
//  Created by Dmitry Demyanov on 01.11.2020.
//

enum ParameterLocation: String {
    case path
    case query
    case body
}

struct ParameterGenerationModel: Equatable {
    
    let name: String
    let serverName: String
    let type: String
    let isOptional: Bool
    let location: ParameterLocation

    init(name: String, serverName: String, type: String, isOptional: Bool = false, location: ParameterLocation) {
        self.name = name
        self.serverName = serverName
        self.type = type
        self.isOptional = isOptional
        self.location = location
    }

}
