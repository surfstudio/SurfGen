//
//  ModelFileGenerator.swift
//  
//
//  Created by Dmitry Demyanov on 01.12.2020.
//

import SurfGenKit
import YamlParser
import PathKit

class ModelFileGenerator {

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

    func generateModels(_ modelNames: [String]) throws {
        let blackList = try configManager.getBlackList()
        let modelTypes = try configManager.getModelTypes()
        logger.printListWithHeader("Black list contains next models:".yellow, list: blackList)
        let generatedModel = tryToGenerate(modelNames: modelNames,
                                           types: modelTypes,
                                           blackList: blackList,
                                           isDescriptionsEnabled: configManager.isDescriptionsEnabled)

        // Handling generation results

        let files = generatedModel.map { $0.value.map { $0.fileName } }.flatMap { $0 }
        logger.printListWithHeader("Surfgen found next dependencies for provided model: ".green, list: files)

        let destinations = try configManager.getModelGenerationPaths()

        // Check for project parameter
        guard let projectPath = configManager.projectPath, let mainGroupName = configManager.mainGroup else {
            logger.print("No project path or mainGroupName specified".yellow)
            logger.print("Generated files pathes: ")
            // Writing files to file system
            let filePathesModel = write(generationModel: generatedModel, to: destinations)
            logger.printGenerationResult(filePathesModel)
            return
        }

        try addFiles(files: files,
                     genModel: generatedModel,
                     projectPath: projectPath,
                     mainGroup: mainGroupName,
                     targets: configManager.targets,
                     destinations: destinations)
    }

    private func tryToGenerate(modelNames: [String],
                       types: [ModelType],
                       blackList: [String],
                       isDescriptionsEnabled: Bool) -> ModelGeneratedModel {
        do {
            let parser = try YamlToGASTParser(string: spec)
            var generatedModels: ModelGeneratedModel = [:]
            for modelName in modelNames {
                let root = try parser.parseToGAST(for: modelName, blackList: blackList)
                let genModel = try rootGenerator.generateModel(from: root,
                                                              types: types,
                                                              generateDescriptions: isDescriptionsEnabled)
                genModel.forEach { generatedModels[$0.key] = $0.value + (generatedModels[$0.key] ?? []) }
            }
            return generatedModels.mapValues { Array(Set($0)) }
        } catch {
            logger.exitWithError(error.localizedDescription)
        }
    }

    private func addFiles(files: [String],
                  genModel: ModelGeneratedModel,
                  projectPath: Path,
                  mainGroup: String,
                  targets: [String],
                  destinations: [ModelType: String]) throws {
        logger.print("Adding generated files to Xcode project named: \(projectPath.lastComponent)...\n".green)
        let manager = try XcodeProjManager(project: projectPath, mainGroupName: mainGroup)
        let existingFiles = manager.findExistingFiles(files)

        logger.printListWithHeader("Next files already exist in project".yellow, list: existingFiles)

        let newFiles = files.filter { !existingFiles.contains($0) }

        guard !newFiles.isEmpty else {
            logger.print("– – – All dependencies already exist in project // in black list – – –\n".yellow)
            return
        }

        let filteredGenModel: ModelGeneratedModel = genModel.mapValues { $0.filter { newFiles.contains($0.fileName) } }
        let filePathesModel = write(generationModel: filteredGenModel, to: destinations)
        logger.printGenerationResult(filePathesModel)

        filePathesModel.forEach { tryToAddFiles(manager: manager, targets: targets, filePathes: $0.value) }

        logger.print("– – – Generation completed! – – –\n".green)
    }

    private func tryToAddFiles(manager: XcodeProjManager, targets: [String], filePathes: [Path]) {
        do {
            try manager.addFiles(filePaths: filePathes, targets: targets)
        } catch {
            logger.exitWithError(error.localizedDescription)
        }
    }

    private func write(generationModel: ModelGeneratedModel, to destinations: [ModelType: String]) -> [ModelType: [Path]] {
        var filePathes = [ModelType: [Path]]()
        for (model, files) in generationModel {
            let destination = destinations[model]
            filePathes[model] = []
            for file in files {
                let outputPath: Path = Path("\(destination ?? "./GeneratedFiles")/\(file.fileName)")
                do {
                    try outputPath.parent().mkpath()
                    try outputPath.write(file.code)
                    filePathes[model]?.append(outputPath)
                } catch {
                    logger.exitWithError(error.localizedDescription)
                }
            }
        }

        return filePathes
    }

}
