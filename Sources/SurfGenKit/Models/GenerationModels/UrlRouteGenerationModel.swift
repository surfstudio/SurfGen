//
//  UrlRouteGenerationModel.swift
//  
//
//  Created by Dmitry Demyanov on 01.11.2020.
//

struct UrlRouteGenerationModel {
    
    let name: String
    let paths: [PathGenerationModel]

    init(name: String, paths: [PathGenerationModel]) {
        self.name = name + "UrlRoute"
        self.paths = paths
    }

}
