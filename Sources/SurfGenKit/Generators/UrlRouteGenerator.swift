//
//  UrlRouteGenerator.swift
//  
//
//  Created by Dmitry Demyanov on 30.10.2020.
//

import Stencil

class UrlRouteGenerator: CodeGenerator {

    func generateCode(for declNode: ASTNode, environment: Environment) throws -> FileModel {
        let declModel = try ServiceDeclNodeParser().getInfo(from: declNode)
        let paths = try declModel.operations
            .map { try OperationNodeParser().parsePath(from: $0) }
            .uniqueElements()
            .sorted { $0.name < $1.name }
        let routeModel = UrlRouteGenerationModel(name: declModel.name, paths: paths)
        let code = try environment.renderTemplate(.urlRoute(routeModel))

        return FileModel(fileName: routeModel.name.withSwiftExt, code: code)
    }

}
