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

    let configPath = Key<String>("--config", "-m", description: "Path to config yaml-file")

    // MARK: - Command execution

    func execute() throws {
        // Initializing RootGenerator with templates

        guard let configPath = configPath.value else {
            exitWithError("No config path was specified")
        }
        let configManager = try ConfigManager(path: Path(configPath))

        let params = (spec: getSpecURL(), names: getModelNames(), type: try configManager.getGenerationTypes())
        let rootGenerator = RootGenerator(tempatesPath: configManager.tempatePath))

        let blackList = try configManager.getBlackList()
        // Generation
        stdout <<< "Generation for \(params.name) with type \(params.type) started..."

        if !blackList.isEmpty {
            stdout <<< "Black list contains next models:".yellow
            printAsList(blackList)
        }

        let generatedCode = tryToGenerate(specURL: params.spec,
                                          modelNames: params.names,
                                          types: params.type,
                                          rootGenerator: rootGenerator,
                                          blackList: blackList)

        let files = generatedCode.map { $0.0 }
        // Handling generation results
        stdout <<< "Surfgen found next dependencies for provided model: ".green
        printAsList(files)

        let destinations = configManager.generationPathes

        // Check for project parameter
        guard let projectPath = configManager.projectPath, let mainGroupName = configManager.mainGroup  else {
            stdout <<< "No project path or mainGroupName specified".yellow
            stdout <<< "Generated files pathes: "
            // Writing files to file system
            let filePathes = write(files: generatedCode, to: destinations[])
            filePathes.forEach { stdout <<< $0.components.joined(separator: "/").green }
            return
        }

        stdout <<< "Adding generated files to Xcode project named: \(projectPath.lastComponent)...\n".green
        let manager = try XcodeProjManager(project: projectPath, mainGroupName: mainGroupName)
        let existingFiles = manager.findExistingFiles(files)

        if !existingFiles.isEmpty {
            stdout <<< "Next files already exist in project".yellow
            printAsList(existingFiles)
        }

        let newFiles = files.filter { !existingFiles.contains($0) }

        guard !newFiles.isEmpty else {
            stdout <<< "– – – All dependencies already exist in project // in black list – – –\n".yellow
            return
        }

        stdout <<< "Next models will be generated:".green
        printAsList(newFiles)

        let filePathes = write(files: generatedCode.filter { newFiles.contains($0.0) })
        tryToAddFiles(manager: manager, targets: configManager.targets, filePathes: filePathes)
        stdout <<< "– – – Generation completed! – – –\n".green
    }

    func tryToAddFiles(manager: XcodeProjManager, targets: [String], filePathes: [Path]) {
        do {
            try manager.addFiles(filePaths: filePathes, targets: targets)
        } catch {
            exitWithError(error.localizedDescription)
        }
    }

    func tryToGenerate(specURL: URL,
                       modelNames: [String],
                       types: [ModelType],
                       rootGenerator: RootGenerator,
                       blackList: [String]) -> [(String, String)] {
        do {
            let parser = try YamlToGASTParser(url: specURL)
            for modelName in modelNames {
                let node = try parser.parseToGAST(for: modelName, blackList: blackList)
                let genModel = try rootGenerator.generateCode(for: node, types: types)
            }
            return genModel.map { $0.value }.flatMap { $0 }
        } catch {
            exitWithError(error.localizedDescription)
        }
    }

    func getSpecURL() -> URL {
        if URL(string: spec.value)?.scheme == nil {
            let path = Path(spec.value).normalize()
            guard path.exists else {
                exitWithError("Could not find spec at \(path)")
            }
            return URL(fileURLWithPath: path.string)
        }
        guard let url = URL(string: spec.value) else {
            exitWithError("No valid spec parameter. It can be a path or a url")
        }
        return url
    }

    func getModelNames() -> [String] {
        guard let modelNames = modelNames.value, !modelNames.isEmpty else {
            exitWithError("--modelName value must be provided")
        }
        return modelNames.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    func write(files: [(fileName: String, fileContent: String)], to destination: String?) -> [Path] {
        var filePathes = [Path]()
        for file in files {
            let outputPath: Path = Path("\(destination ?? "./GeneratedFiles")/\(file.fileName)")
            do {
                try outputPath.parent().mkpath()
                try outputPath.write(file.fileContent)
                filePathes.append(outputPath)
            } catch {
                exitWithError(error.localizedDescription)
            }
        }
        return filePathes
    }

    func printAsList(_ list: [String]) {
        stdout <<< "---------------------------------------".bold
        list.forEach { stdout <<< "• " + $0 }
        stdout <<< "---------------------------------------\n".bold
    }

    func exitWithError(_ string: String) -> Never {
        stderr <<< string.red
        exit(EXIT_FAILURE)
    }

}
