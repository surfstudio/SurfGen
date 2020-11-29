//
//  ServiceGenerator.swift
//  
//
//  Created by Dmitry Demyanov on 04.11.2020.
//

import Stencil

public class ServiceGenerator {

    private enum Constants {
        static let errorMessage = "Could not generate code for service"
    }

    private let declNodeParser: ServiceDeclNodeParser
    private let operationNodeParser: OperationNodeParser

    init(declNodeParser: ServiceDeclNodeParser, operationNodeParser: OperationNodeParser) {
        self.declNodeParser = declNodeParser
        self.operationNodeParser = operationNodeParser
    }

    public static var defaultGenerator: ServiceGenerator {
        let declNodeParser = ServiceDeclNodeParser()
        let mediaContentParser = MediaContentNodeParser()
        let parametersParser = ParametersNodeParser()
        let operationNodeParser = OperationNodeParser(mediaContentParser: mediaContentParser,
                                                      parametersParser: parametersParser)
        return .init(declNodeParser: declNodeParser, operationNodeParser: operationNodeParser)
    }

    func generateCode(for declNode: ASTNode,
                      withServiceName serviceName: String,
                      environment: Environment) throws -> ServiceGeneratedModel {
        let declModel = try wrap(declNodeParser.getInfo(from: declNode),
                                 with: Constants.errorMessage)
        let operations = try wrap(declModel.operations
                                    .map { try operationNodeParser.parse(operation: $0,
                                                                         rootPath: declModel.name) }
                                    .flatMap { OperationSplitter().splitMultipleBodyOptions(operation: $0) }
                                    .sorted { $0.signature < $1.signature },
                                  with: Constants.errorMessage)

        let paths = operations
            .map { $0.path }
            .uniqueElements()
            .sorted { $0.name < $1.name }

        let keys = operations
            .flatMap { $0.queryParameters + ($0.requestBody?.parameters ?? []) }
            .map { $0.serverName }
            .uniqueElements()
            .map { CodingKey(name: $0.snakeCaseToCamelCase(), serverName: $0) }
            .sorted { $0.name < $1.name }

        let serviceModel = ServiceGenerationModel(name: serviceName.capitalizingFirstLetter(),
                                                  keys: keys,
                                                  paths: paths,
                                                  operations: operations)

        let routeCode = try environment.renderTemplate(.urlRoute(serviceModel))
        let protocolCode = try environment.renderTemplate(.serviceProtocol(serviceModel))
        let serviceCode = try environment.renderTemplate(.service(serviceModel))

        return [
            .urlRoute: FileModel(fileName: ServicePart.urlRoute.buildName(for: serviceModel.name).withSwiftExt,
                                 code: routeCode),
            .protocol: FileModel(fileName: ServicePart.protocol.buildName(for: serviceModel.name).withSwiftExt,
                                 code: protocolCode),
            .service: FileModel(fileName: ServicePart.service.buildName(for: serviceModel.name).withSwiftExt,
                                code: serviceCode)
        ]
    }

}

private extension OperationGenerationModel {

    var signature: String {
        return [
            name,
            requestBody?.modelName ?? "",
            requestBody?.parameters?.map { $0.name }.joined() ?? ""
        ].joined(separator: "+")
    }

}
