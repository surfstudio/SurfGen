//
//  ServiceGenerationModel.swift
//  
//
//  Created by Dmitry Demyanov on 13.01.2021.
//

import Foundation

/// Keeps all information required to fill service templates
public struct ServiceGenerationModel {

    public let name: String
    public let apiDefinitionFileRef: String
    public let paths: [PathGenerationModel]
    public let codingKeys: [String]

    public init(name: String, paths: [PathGenerationModel], apiDefinitionFileRef: String) {
        self.name = name
        self.apiDefinitionFileRef = apiDefinitionFileRef
        self.paths = paths.sorted { $0.name < $1.name }
        self.codingKeys = paths
            .flatMap { $0.codingKeys }
            .uniqueElements()
            .sorted()
    }
}
