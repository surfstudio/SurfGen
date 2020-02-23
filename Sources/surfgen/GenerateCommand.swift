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

    let target = VariadicKey<String>("--taget", "-tgt", description: "Target in provided Project for generated files")

    let mainGroupName = Key<String>("-mainGroup", "-mg", description: "Name of root main project directory. Used to detect correct subgroup in project tree")

    // MARK: - Command execution

    func execute() throws {
        let params = (spec: getSpecURL(), name: getModelName(), type: getModelType())
        let rootGenerator = RootGenerator(tempatesPath: "./Templates")
        stdout <<< "Generation for \(params.name) started ...".green
        let generatedCode = tryToGenerate(specURL: params.spec,
                                          modelName: params.name,
                                          type: params.type,
                                          rootGenerator: rootGenerator)

        stdout <<< "Next files will be generated: ".green
        generatedCode.forEach { stdout <<< $0.0 }
        let filePathes = write(files: generatedCode)

        guard let projectPath = project.value, let mainGroupName = mainGroupName.value else {
            stdout <<< "No project path or mainGroupName specified".yellow
            stdout <<< "Generated files pathes: "
            filePathes.forEach { stdout <<< $0.components.joined(separator: "/").green }

            return
        }

        stdout <<< "Adding generated files to Xcode project ...".green

        let manager = try XcodeProjManager(project: Path(projectPath), mainGroupName: mainGroupName)
        try manager.addFiles(filePaths: filePathes, targets: target.value)

        stdout <<< "Adding generated files to Xcode project ...".green

    }

    func tryToGenerate(specURL: URL, modelName: String, type: ModelType, rootGenerator: RootGenerator) -> [(String, String)] {
        do {
            let parser = try YamlToGASTParser(url: specURL)
            let node = try parser.parseToGAST(for: modelName)
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
            return .entity
        case .nodeKitEntity?:
            return .entry
        case .none:
            exitWithError("--type value must be one of [nodeKitEntry, nodeKitEntity]")
        }
    }

    func write(files: [(fileName: String, fileContent: String)]) -> [Path] {
        var filePathes = [Path]()
        for file in files {
            let outputPath: Path = Path("./\(destination.value ?? "GeneratedFiles")/\(file.fileName)")
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

    func tryToAddFiles() {
        do {


        } catch {
            exitWithError(error.localizedDescription)
        }
    }

    func exitWithError(_ string: String) -> Never {
        stderr <<< string.red
        exit(EXIT_FAILURE)
    }

}

