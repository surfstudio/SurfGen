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

    let spec = SwiftCLI.Parameter()

    let modelNames = Key<String>("--modelNames", "-m", description: "Model names to be generated. Example: --modelNames Order,StatusType")

    let configPath = Key<String>("--config", "-c", description: "Path to config yaml-file")

    // MARK: - Command execution

    func execute() throws {
        guard let configPath = configPath.value else {
            exitWithError("No config path was specified")
        }
        let configManager = try ConfigManager(path: Path(configPath))

        let params = (spec: try getSpec(token: configManager.gitlabToken),
                      names: getModelNames(),
                      types: try configManager.getGenerationTypes())

        let rootGenerator = RootGenerator(tempatesPath: configManager.tempatePath)

        let blackList = try configManager.getBlackList()
        // Generation
        stdout <<< "Generation for \(params.names) started..."
        printListWithHeader("Black list contains next models:".yellow, list: blackList)

        let generatedModel = tryToGenerate(spec: params.spec,
                                           modelNames: params.names,
                                           types: params.types,
                                           rootGenerator: rootGenerator,
                                           blackList: blackList,
                                           isDescriptionsEnabled: configManager.isDescriptionsEnabled)

        // Handling generation results

        let files = generatedModel.map { $0.value.map { $0.fileName } }.flatMap { $0 }
        printListWithHeader("Surfgen found next dependencies for provided model: ".green, list: files)

        let destinations = configManager.generationPathes

        // Check for project parameter
        guard let projectPath = configManager.projectPath, let mainGroupName = configManager.mainGroup  else {
            stdout <<< "No project path or mainGroupName specified".yellow
            stdout <<< "Generated files pathes: "
            // Writing files to file system
            let filePathesModel = write(generationModel: generatedModel, to: destinations)
            printGenerationResult(filePathesModel)
            return
        }

        try addFiles(files: files,
                     genModel: generatedModel,
                     projectPath: projectPath,
                     mainGroup: mainGroupName,
                     targets: configManager.targets,
                     destinations: destinations)
    }

    func addFiles(files: [String],
                  genModel: ModelGenerationModel,
                  projectPath: Path,
                  mainGroup: String,
                  targets: [String],
                  destinations: [ModelType: String]) throws {
        stdout <<< "Adding generated files to Xcode project named: \(projectPath.lastComponent)...\n".green
        let manager = try XcodeProjManager(project: projectPath, mainGroupName: mainGroup)
        let existingFiles = manager.findExistingFiles(files)

        printListWithHeader("Next files already exist in project".yellow, list: existingFiles)

        let newFiles = files.filter { !existingFiles.contains($0) }

        guard !newFiles.isEmpty else {
            stdout <<< "– – – All dependencies already exist in project // in black list – – –\n".yellow
            return
        }

        let filteredGenModel: ModelGenerationModel = genModel.mapValues { $0.filter { newFiles.contains($0.fileName) } }
        let filePathesModel = write(generationModel: filteredGenModel, to: destinations)
        printGenerationResult(filePathesModel)

        filePathesModel.forEach { tryToAddFiles(manager: manager, targets: targets, filePathes: $0.value) }

        stdout <<< "– – – Generation completed! – – –\n".green
    }

    func tryToAddFiles(manager: XcodeProjManager, targets: [String], filePathes: [Path]) {
        do {
            try manager.addFiles(filePaths: filePathes, targets: targets)
        } catch {
            exitWithError(error.localizedDescription)
        }
    }

    func tryToGenerate(spec: String,
                       modelNames: [String],
                       types: [ModelType],
                       rootGenerator: RootGenerator,
                       blackList: [String],
                       isDescriptionsEnabled: Bool) -> ModelGenerationModel {
        do {
            let parser = try YamlToGASTParser(string: spec)
            var generatedModels: ModelGenerationModel = [:]
            for modelName in modelNames {
                let root = try parser.parseToGAST(for: modelName, blackList: blackList)
                let genModel = try rootGenerator.generateModel(from: root,
                                                              types: types,
                                                              generateDescriptions: isDescriptionsEnabled)
                genModel.forEach { generatedModels[$0.key] = $0.value + (generatedModels[$0.key] ?? []) }
            }
            return generatedModels.mapValues { Array(Set($0)) }
        } catch {
            exitWithError(error.localizedDescription)
        }
    }

    func getSpec(token: String?) throws -> String {
        guard URL(string: spec.value)?.scheme == nil else {
            return try FileLoader().loadFile(spec.value, token: token)
        }

        let path = Path(spec.value).normalize()
        guard path.exists else {
            exitWithError("Could not find spec at \(path)")
        }
        return try path.read()
    }

    func getModelNames() -> [String] {
        guard let modelNames = modelNames.value, !modelNames.isEmpty else {
            exitWithError("--modelName value must be provided")
        }
        return modelNames.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    func write(generationModel: ModelGenerationModel, to destinations: [ModelType: String]) -> [ModelType: [Path]] {
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
                    exitWithError(error.localizedDescription)
                }
            }
        }

        return filePathes
    }


}

// MARK: - Console Info Output method

private extension GenerateCommand {

    func printAsList(_ list: [String]) {
        stdout <<< "---------------------------------------".bold
        list.forEach { stdout <<< "• " + $0 }
        stdout <<< "---------------------------------------\n".bold
    }

    func printGenerationResult(_ result: [ModelType: [Path]]) {
        result.forEach {
            switch $0.key {
            case .entity:
                printListWithHeader("Next Enities were generated:".green, list: $0.value.map { $0.lastComponent })
            case .entry:
                printListWithHeader("Next Entries were generated".green, list: $0.value.map { $0.lastComponent })
            case .enum:
                printListWithHeader("Next Enums were generated".green, list: $0.value.map { $0.lastComponent })
            }
        }
    }

    func printListWithHeader(_ header: String, list: [String]) {
        guard !list.isEmpty else { return }
        stdout <<< header
        printAsList(list)
    }

    func exitWithError(_ string: String) -> Never {
        stderr <<< string.red
        exit(EXIT_FAILURE)
    }

}
