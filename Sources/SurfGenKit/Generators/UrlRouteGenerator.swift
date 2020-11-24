//
//  UrlRouteGenerator.swift
//  
//
//  Created by Dmitry Demyanov on 30.10.2020.
//

import Stencil

class UrlRouteGenerator: CodeGenerator {

    private enum Constants {
        static let errorMessage = "Could not generate code for route list"
    }

    func generateCode(for declNode: ASTNode, environment: Environment) throws -> FileModel {
        let declModel = try wrap(ServiceDeclNodeParser().getInfo(from: declNode),
                                 with: Constants.errorMessage)
        let paths = try wrap(declModel.operations
                                .map { try OperationNodeParser().parsePath(from: $0) }
                                .uniqueElements()
                                .sorted { $0.name < $1.name },
                             with: Constants.errorMessage)
        let routeModel = UrlRouteGenerationModel(name: declModel.name, paths: paths)
        let code = try environment.renderTemplate(.urlRoute(routeModel))

        return FileModel(fileName: routeModel.name.withSwiftExt, code: code)
    }

}
