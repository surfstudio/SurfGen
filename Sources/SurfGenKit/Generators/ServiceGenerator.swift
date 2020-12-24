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

    private let platform: Platform

    init(declNodeParser: ServiceDeclNodeParser, operationNodeParser: OperationNodeParser, platform: Platform) {
        self.declNodeParser = declNodeParser
        self.operationNodeParser = operationNodeParser
        self.platform = platform
    }

    public static func defaultGenerator(for platform: Platform) -> ServiceGenerator {
        let declNodeParser = ServiceDeclNodeParser()
        let mediaContentParser = MediaContentNodeParser(platform: platform)
        let parametersParser = ParametersNodeParser(platform: platform)
        let operationNodeParser = OperationNodeParser(mediaContentParser: mediaContentParser,
                                                      parametersParser: parametersParser,
                                                      platform: platform)
        return .init(declNodeParser: declNodeParser, operationNodeParser: operationNodeParser, platform: platform)
    }

    func generateCode(for declNode: ASTNode,
                      withServiceName serviceName: String,
                      parts: [ServicePart],
                      environment: Environment) throws -> ServiceGeneratedModel {
        let serviceModel = try buildServiceModel(for: declNode, withServiceName: serviceName)

        return try parts.reduce(into: ServiceGeneratedModel()) { model, part in
            let fileName = part.buildName(for: serviceModel.name,
                                          platform: platform).withFileExtension(platform.fileExtension)
            model[part] = FileModel(fileName: fileName,
                                    code: try environment.renderTemplate(Template.service(serviceModel),
                                                                         from: part.templateName(for: platform)))
        }
    }

    private func buildServiceModel(for declNode: ASTNode,
                                   withServiceName serviceName: String) throws -> ServiceGenerationModel {
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

        return ServiceGenerationModel(name: serviceName.capitalizingFirstLetter(),
                                      keys: keys,
                                      paths: paths,
                                      operations: operations)
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
