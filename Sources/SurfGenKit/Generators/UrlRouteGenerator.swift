//
//  UrlRouteGenerator.swift
//  
//
//  Created by Dmitry Demyanov on 30.10.2020.
//

import Stencil

class UrlRouteGenerator: CodeGenerator {

    func generateCode(declNode: ASTNode, environment: Environment) throws -> FileModel {
        let declModel = try ServiceDeclNodeParser().getInfo(from: declNode)
        let paths = try Set(declModel.operations.map { operation -> PathGenerationModel in
            guard
                let pathNode = operation.subNodes.pathNode,
                case let .path(path) = pathNode.token
            else {
                throw GeneratorError.nodeConfiguration("Couldn't get path node from operation")
            }
            var parameters = [ParameterGenerationModel]()
            if let parametersNode = operation.subNodes.parametersNode {
                parameters = try ParametersNodeParser().parseParameters(node: parametersNode, location: .path)
            }
            return PathGenerationModel(name: path.pathName,
                                       path: path.pathWithSwiftParameters(),
                                       parameters: parameters.map { $0.name })
        })
        let routeModel = UrlRouteGenerationModel(name: declModel.name, paths: Array(paths))
        let code = try environment.renderTemplate(.urlRoute(routeModel))
        print(code)
        return FileModel(fileName: routeModel.name, code: code)
    }

}
