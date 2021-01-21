//
//  ServiceGenerationModel.swift
//  
//
//  Created by Dmitry Demyanov on 13.01.2021.
//

import Foundation

/// Keeps all information required to fill service templates
public struct ServiceGenerationModel {

    let name: String
    let paths: [ServiceModel]

    public init(name: String, paths: [ServiceModel]) {
        self.name = name
        self.paths = paths
    }
}
