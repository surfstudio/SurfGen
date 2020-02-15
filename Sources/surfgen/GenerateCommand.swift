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

    // MARK: - Command execution

    func execute() throws {
        tryToAddFiles()
        let params = (spec: getSpecURL(), name: getModelName(), type: getModelType())
        let rootGenerator = RootGenerator(tempatesPath: "./Templates")
        tryToGenerate(specURL: params.spec,
                      modelName: params.name,
                      type: params.type,
                      rootGenerator: rootGenerator)
    }

    func tryToGenerate(specURL: URL, modelName: String, type: ModelType, rootGenerator: RootGenerator) {
        do {
            let parser = try YamlToGASTParser(url: specURL)
            let node = try parser.parseToGAST(for: modelName)
            let generatedCode = try rootGenerator.generateCode(for: node, type: type)
            write(files: generatedCode)
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

    func write(files: [(fileName: String, fileContent: String)]) {
        for file in files {
            let outputPath: Path = Path("./\(destination.value ?? "GeneratedFiles")/\(file.fileName)")
            do {
                try outputPath.parent().mkpath()
                try outputPath.write(file.fileContent)
            } catch {
                exitWithError(error.localizedDescription)
            }
        }
    }

    func tryToAddFiles() {
        do {
            let proj = try XcodeProj(path: Path(project.value ?? ""))
            let pbxproj = proj.pbxproj

            let dest = Path(destination.value ?? "")
            let root = Path(project.value ?? "")

            let fileRef = try pbxproj.projects.first?.mainGroup.addFile(at: dest, sourceRoot: root)

            try pbxproj.nativeTargets.forEach {

                if $0.name == "Models" {
                    print("did found")

                    let element = PBXFileElement(sourceTree: fileRef?.sourceTree,
                                                 path: fileRef?.path,
                                                 name: fileRef?.name,
                                                 includeInIndex: fileRef?.includeInIndex,
                                                 usesTabs: fileRef?.usesTabs,
                                                 indentWidth: fileRef?.indentWidth,
                                                 tabWidth: fileRef?.tabWidth,
                                                 wrapsLines: fileRef?.wrapsLines)
                    let tmp = try $0.sourcesBuildPhase()?.add(file: element)
                    print(tmp)

                }
            }

            try proj.write(path: root, override: true)
        } catch {
            exitWithError(error.localizedDescription)
        }
    }

    func exitWithError(_ string: String) -> Never {
        stderr <<< string
        exit(EXIT_FAILURE)
    }

}
