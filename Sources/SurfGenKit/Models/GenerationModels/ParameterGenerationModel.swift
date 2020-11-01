//
//  ParameterGenerationModel.swift
//  
//
//  Created by Dmitry Demyanov on 01.11.2020.
//

enum ParameterLocation: String {
    case path
    case query
}

struct ParameterGenerationModel {
    let name: String
    let isOptional: Bool
    let location: ParameterLocation
}
