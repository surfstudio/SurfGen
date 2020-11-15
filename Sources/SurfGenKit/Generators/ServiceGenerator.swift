//
//  ServiceGenerator.swift
//  
//
//  Created by Dmitry Demyanov on 04.11.2020.
//

import Stencil

class ServiceGenerator {
    
    func generateCode(for declNode: ASTNode, environment: Environment) throws -> (protocol: FileModel,
                                                                                  service: FileModel) {
        let declModel = try ServiceDeclNodeParser().getInfo(from: declNode)
        let operations = try declModel.operations
            .map { try OperationNodeParser().parse(operation: $0, forServiceName: declModel.name) }
            .sorted { $0.name < $1.name }
        let keys = operations
            .flatMap { $0.queryParameters + ($0.bodyParameters ?? []) }
            .map { $0.serverName }
            .uniqueElements()
            .map { CodingKey(name: $0.snakeCaseToCamelCase(), serverName: $0) }
            .sorted { $0.name < $1.name }

        let serviceModel = ServiceGenerationModel(name: declModel.name, keys: keys, operations: operations)
        let protocolCode = try environment.renderTemplate(.serviceProtocol(serviceModel))
        let serviceCode = try environment.renderTemplate(.service(serviceModel))

        return (FileModel(fileName: serviceModel.protocolName.withSwiftExt, code: protocolCode),
                FileModel(fileName: serviceModel.serviceName.withSwiftExt, code: serviceCode))
    }

}
