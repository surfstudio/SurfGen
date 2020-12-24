//
//  PathGenerationModel.swift
//  
//
//  Created by Dmitry Demyanov on 31.10.2020.
//


public struct PathGenerationModel: Hashable {

    let name: String
    let constName: String
    let path: String
    let parameters: [String]
    let hasParameters: Bool

    init(name: String, constName: String, path: String, parameters: [String]) {
        self.name = name
        self.constName = constName
        self.path = path
        self.parameters = parameters
        self.hasParameters = !parameters.isEmpty
    }

}
