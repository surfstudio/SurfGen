//
//  ServiceGenerator.swift
//  
//
//  Created by Dmitry Demyanov on 04.11.2020.
//

import Stencil

class ServiceGenerator {
    
    private enum Constants {
        static let errorMessage = "Could not generate code for service"
    }
    
    func generateCode(for declNode: ASTNode, environment: Environment) throws -> (protocol: FileModel,
                                                                                  service: FileModel) {
        let declModel = try wrap(ServiceDeclNodeParser().getInfo(from: declNode),
                                 with: Constants.errorMessage)
        let operations = try wrap(declModel.operations
                                    .map { try OperationNodeParser().parse(operation: $0,
                                                                           forServiceName: declModel.name) }
                                    .sorted { $0.name < $1.name },
                                  with: Constants.errorMessage)
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
