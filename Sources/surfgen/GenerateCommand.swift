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

final class GenerateCommand: Command {

    // MARK: - Nested types

    private enum GeneratedModelType: String {
        case nodeKitEntry
        case nodeKitEntity
    }

    let name = "generate"
    let shortDescription = "Generates models for provided spec"

    // MARK: - Command parameters

    let spec = SwiftCLI.Parameter()

    let modelName = Key<String>("--modelName", "-m", description: "Model name to be generated")

    let destination = Key<String>("--destination", "-d", description: "The directory where the generated files will be created. Defaults to \"GeneratedFiles\"")

    let type = Key<String>("--type", "-t", description: "Type of models supposed to be generated, current values: \"nodeKitEntry\" and \"nodeKitEntity\"")

    let project = Key<String>("--project", "-p", description: "Path to .xcodeproj file where generated files are supposed to be added")

    let target = VariadicKey<String>("--target", "-tgt", description: "Target in provided Project for generated files")

    let mainGroupName = Key<String>("--mainGroup", "-mg", description: "Name of root main project directory. Used to detect correct subgroup in project tree")

    let templatesPath = Key<String>("--templates", "-tmpls", description: "Path to template files. Default value: ./Templates")

    let blackList = Key<String>("--black_list", "-bl", description: "Path to black list file. Model names in this list will be ignored during generation proccess")

    // MARK: - Command execution

    func execute() throws {
        // Initializing RootGenerator with templates
        let params = (spec: getSpecURL(), name: getModelName(), type: getModelType())
        let rootGenerator = RootGenerator(tempatesPath: Path(templatesPath.value ?? "./Templates"))
        let blackList = getBlackList()
        // Generation
        stdout <<< "Generation for \(params.name) with type \(params.type) started..."

        if !blackList.isEmpty {
            stdout <<< "Black list contains next models:".yellow
            printAsList(blackList)
        }

        let generatedCode = tryToGenerate(specURL: params.spec,
                                          modelName: params.name,
                                          type: params.type,
                                          rootGenerator: rootGenerator,
                                          blackList: blackList)

        let files = generatedCode.map { $0.0 }
        // Handling generation results
        stdout <<< "Surfgen found next dependencies for provided model: ".green
        printAsList(files)

        // Check for project parameter
        guard let projectPath = project.value, let mainGroupName = mainGroupName.value else {
            stdout <<< "No project path or mainGroupName specified".yellow
            stdout <<< "Generated files pathes: "
            // Writing files to file system
            let filePathes = write(files: generatedCode)
            filePathes.forEach { stdout <<< $0.components.joined(separator: "/").green }
            return
        }

        let pathToProject = Path(projectPath)
        stdout <<< "Adding generated files to Xcode project named: \(pathToProject.lastComponent)...\n".green
        let manager = try XcodeProjManager(project: pathToProject, mainGroupName: mainGroupName)
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
        tryToAddFiles(manager: manager, targets: target.value, filePathes: filePathes)
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
                       modelName: String,
                       type: ModelType,
                       rootGenerator: RootGenerator,
                       blackList: [String]) -> [(String, String)] {
        do {
            let parser = try YamlToGASTParser(url: specURL)
            let node = try parser.parseToGAST(for: modelName, blackList: blackList)
            return try rootGenerator.generateCode(for: node, type: type)
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

    func getModelName() -> String {
        guard let modelName = modelName.value, !modelName.isEmpty else {
            exitWithError("--modelName value must be provided")
        }
        return modelName
    }

    func getModelType() -> ModelType {
        guard let typeName = type.value else {
            exitWithError("--type value must be provided [nodeKitEntry, nodeKitEntity] avaliable")
        }
        switch GeneratedModelType(rawValue: typeName) {
        case .nodeKitEntry?:
            return .entry
        case .nodeKitEntity?:
            return .entity
        case .none:
            exitWithError("--type value must be one of [nodeKitEntry, nodeKitEntity]")
        }
    }

    func getBlackList() -> [String] {
        guard let blackList = blackList.value else {
            return []
        }
        do {
            let blackListFile: String = try Path(blackList).read()
            return blackListFile.split(separator: "\n").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
        } catch {
            exitWithError(error.localizedDescription)
        }
    }

    func write(files: [(fileName: String, fileContent: String)]) -> [Path] {
        var filePathes = [Path]()
        for file in files {
            let outputPath: Path = Path("\(destination.value ?? "./GeneratedFiles")/\(file.fileName)")
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
