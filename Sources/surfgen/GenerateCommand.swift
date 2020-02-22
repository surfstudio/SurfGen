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
            let root = Path(project.value ?? "")
            let dest = Path(destination.value ?? "")

            let proj = try XcodeProj(path: root)

            let components = dest.components.dropLast()
            let mainGroupDir = "Models"

            guard let mainGroup = proj.pbxproj.projects.first!.mainGroup.children.first(where: { $0.path == mainGroupDir }) else {
                return
            }

            guard let index = components.firstIndex(where: { $0 == mainGroupDir }) else {
                return
            }


            let subCompents = components[index...].dropFirst()
            if let groupToBeAdded = (mainGroup as? PBXGroup)?.group(for: Array(subCompents)) {
                groupToBeAdded.children.forEach { print($0.name) }
            }



        } catch {
            exitWithError(error.localizedDescription)
        }
    }

    func exitWithError(_ string: String) -> Never {
        stderr <<< string.red
        exit(EXIT_FAILURE)
    }

}

public extension PBXGroup {

    func group(for components: [String]) -> PBXGroup? {
        var iteratorGroup: PBXGroup? = self
        print(iteratorGroup?.children.map { $0.path })
        for component in components {
            iteratorGroup = group(named: component)
        }
        return iteratorGroup
    }

}

