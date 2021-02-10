//
//  ServiceFileGenerator.swift
//  
//
//  Created by Dmitry Demyanov on 01.12.2020.
//

import SurfGenKit
import YamlParser
import PathKit

class ServiceFileGenerator {

    let configManager: ConfigManager
    let rootGenerator: RootGenerator

    let spec: String

    let logger =  Logger()

    init(configManager: ConfigManager,
                  rootGenerator: RootGenerator,
                  spec: String) {
        self.configManager = configManager
        self.rootGenerator = rootGenerator
        self.spec = spec
    }

    func generateService(_ serviceName: String, rootPath: String) throws {
        let generator = try ServiceGenerator.defaultGenerator(for: configManager.getPlatform())
        let destinations = try configManager.getServiceGenerationPaths(for: serviceName)
        let generatedService = tryToGenerate(serviceName: serviceName,
                                             rootPath: rootPath,
                                             parts: Array(destinations.keys),
                                             isDescriptionsEnabled: configManager.isDescriptionsEnabled,
                                             serviceGenerator: generator)
        logger.print(rootGenerator.warningsLog.yellow + "\n")

        guard let projectPath = configManager.projectPath, let mainGroupName = configManager.mainGroup else {
            logger.print("No project path or mainGroupName specified\n".yellow)
            logger.print("Generated files:")
            // Writing files to file system
            let filePathsModel = write(generatedService: generatedService, to: destinations)
            logger.printGenerationResult(filePathsModel)
            return
        }

        try addFiles(genModel: generatedService,
                 projectPath: projectPath,
                 mainGroup: mainGroupName,
                 targets: configManager.targets,
                 destinations: destinations)
    }

    private func tryToGenerate(serviceName: String,
                               rootPath: String,
                               parts: [ServicePart],
                               isDescriptionsEnabled: Bool,
                               serviceGenerator: ServiceGenerator) -> ServiceGeneratedModel {
        do {
            let parser = try YamlToGASTParser(string: spec)
            let service = try parser.parseToGAST(forServiceRootPath: rootPath)
            rootGenerator.setServiceGenerator(serviceGenerator)
            return try rootGenerator.generateService(name: serviceName,
                                                     from: service,
                                                     parts: parts,
                                                     generateDescriptions: isDescriptionsEnabled)
        } catch {
            logger.exitWithError(error.localizedDescription)
        }
    }

    private func addFiles(genModel: ServiceGeneratedModel,
                  projectPath: Path,
                  mainGroup: String,
                  targets: [String],
                  destinations: [ServicePart: String]) throws {
        logger.print("Adding generated files to Xcode project named: \(projectPath.lastComponent)...\n".green)
        let manager = try XcodeProjManager(project: projectPath, mainGroupName: mainGroup)
        let files = genModel.map { $0.value.fileName }
        let existingFiles = manager.findExistingFiles(files)

        logger.printListWithHeader("Next files already exist in project".yellow, list: existingFiles)

        let newFiles = files.filter { !existingFiles.contains($0) }

        guard !newFiles.isEmpty else {
            logger.print("– – – All dependencies already exist in project – – –\n".yellow)
            return
        }

        let filteredGenModel = genModel.filter { newFiles.contains($0.value.fileName) }
        let filePathsModel = write(generatedService: filteredGenModel, to: destinations)
        logger.printGenerationResult(filePathsModel)

        tryToAddFiles(manager: manager, targets: targets, filePaths: Array(filePathsModel.values))

        logger.print("– – – Generation completed! – – –\n".green)
    }

    private func tryToAddFiles(manager: XcodeProjManager, targets: [String], filePaths: [Path]) {
        do {
            try manager.addFiles(filePaths: filePaths, targets: targets)
        } catch {
            logger.exitWithError(error.localizedDescription)
        }
    }

    private func write(generatedService: ServiceGeneratedModel,
                       to destinations: [ServicePart: String]) -> [ServicePart: Path] {
        var filePaths = [ServicePart: Path]()
        for (service, file) in generatedService {
            let destination = destinations[service]
            let outputPath = Path("\(destination ?? "./GeneratedFiles")/\(file.fileName)")
            do {
                try outputPath.parent().mkpath()
                try outputPath.write(file.code)
                filePaths[service] = outputPath
            } catch {
                logger.exitWithError(error.localizedDescription)
            }
        }

        return filePaths
    }

}
