//
//  GenerateCommand.swift
//  
//
//  Created by Mikhail Monakov on 01/02/2020.
//

import SwiftCLI
import SurfGenKit
import Foundation
import PathKit
import YamlParser
import XcodeProj
import Rainbow
import Yams

final class GenerateCommand: Command {

    let name = "generate"
    let shortDescription = "Generates models for provided spec"

    // MARK: - Command parameters

    let specPath = SwiftCLI.Parameter()

    let modelNames = Key<String>("--modelNames", "-m", description: "Model names to be generated. Example: --modelNames Order,StatusType")
    
    let serviceName = Key<String>("--serviceName", "-s", description: "Service name to be generated. Example: --serviceName Profile")

    let serviceRootPath = Key<String>("--rootPath", "-r", description: "Service root path. Example: --rootPath user/profile")

    let configPath = Key<String>("--config", "-c", description: "Path to config yaml-file")

    var modelGenerator: ModelFileGenerator!
    var serviceGenerator: ServiceFileGenerator!

    // MARK: - Command execution

    func execute() throws {
        guard let configPath = configPath.value else {
            exitWithError("No config path was specified")
        }

        let generationType = getGenerationType()
        let configManager = try ConfigManager(path: Path(configPath))
        let rootGenerator = try RootGenerator(tempatesPath: configManager.templatePath,
                                              platform: configManager.getPlatform())
        let spec = try getSpec(token: configManager.gitlabToken)
        
        stdout <<< "Generation for \(generationType.description) started..."
        
        switch generationType {
        case .models(let modelNames):
            let modelGenerator = ModelFileGenerator(configManager: configManager,
                                                    rootGenerator: rootGenerator,
                                                    spec: spec)
            try modelGenerator.generateModels(modelNames)
        case .service(let serviceName):
            let serviceGenerator = ServiceFileGenerator(configManager: configManager,
                                                    rootGenerator: rootGenerator,
                                                    spec: spec)
            try serviceGenerator.generateService(serviceName, rootPath: serviceRootPath.value ?? serviceName)
        }
    }

    func getSpec(token: String?) throws -> String {
        guard URL(string: specPath.value)?.scheme == nil else {
            return try FileLoader().loadFile(specPath.value, token: token)
        }

        let path = Path(specPath.value).normalize()
        guard path.exists else {
            exitWithError("Could not find spec at \(path)")
        }
        return try path.read()
    }

    func getGenerationType() -> GenerationType {
        if let modelNames = modelNames.value, !modelNames.isEmpty {
            return .models(modelNames
                            .split(separator: ",")
                            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) })
        }
        if let serviceName = serviceName.value, !serviceName.isEmpty {
            return .service(serviceName)
        }
        exitWithError("--modelNames or --serviceName value must be provided")
    }

    func getModelNames() -> [String] {
        guard let modelNames = modelNames.value, !modelNames.isEmpty else {
            exitWithError("--modelName value must be provided")
        }
        return modelNames.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    func exitWithError(_ string: String) -> Never {
        stderr <<< string.red
        exit(EXIT_FAILURE)
    }

}
