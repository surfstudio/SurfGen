//
//  ConfigManager.swift
//  surfgen
//
//  Created by Mikhail Monakov on 20/03/2020.
//

import Yams
import PathKit
import SurfGenKit

enum ConfigManagerError: Error {
    case incorrectYamlFile
    case incorrectGenerationType
}

final class ConfigManager {

    // MARK: - Nested types

    private enum GeneratedModelType: String {
        case nodeKitEntry
        case nodeKitEntity
        case `enum`
    }

    // MARK: - Properties

    var templatePath: Path {
        return Path(model.templatesPath)
    }

    var projectPath: Path? {
        guard let path = model.projectPath else {
            return nil
        }
        return Path(path)
    }

    var mainGroup: String? {
        guard let group = model.mainGroup else {
            return nil
        }
        return group
    }

    var targets: [String] {
        return model.targets ?? []
    }

    var gitlabToken: String? {
        return model.gitlabToken
    }

    var isDescriptionsEnabled: Bool {
        return model.generateDescriptions ?? false
    }

    // MARK: - Private Properties

    private let model: ConfigModel

    // MARK: - Initialization

    init(path: Path) throws {
        let config: String = try path.read()
        let decoder = YAMLDecoder()
        self.model = try decoder.decode(ConfigModel.self, from: config)
    }

    // MARK: - Internal methods

    func getPlatform() throws -> Platform {
        guard let platform = Platform(rawValue: model.platform) else {
            throw SurfGenError(nested: ConfigManagerError.incorrectYamlFile,
                               message: "Could not get platform")
        }
        return platform
    }

    func getModelGenerationPaths() throws -> [ModelType: String] {
        guard
            let entitiesPath = model.entitiesPath,
            let entriesPath = model.entriesPath,
            let enumPath = model.enumPath
        else {
            throw SurfGenError(nested: ConfigManagerError.incorrectYamlFile,
                               message: "Could not get model generation paths")
        }
        return [
            .entity: entitiesPath,
            .entry: entriesPath,
            .enum: enumPath
        ]
    }

    func getServiceGenerationPaths(for serviceName: String) throws -> [ServicePart: String] {
        guard
            let endpointsPath = model.endpointsPath,
            let servicesPath = model.servicesPath
        else {
            throw SurfGenError(nested: ConfigManagerError.incorrectYamlFile,
                               message: "Could not get service generation paths")
        }
        let fullServicePath = "\(servicesPath)/\(serviceName.capitalizingFirstLetter())"
        return [
            .urlRoute: endpointsPath,
            .protocol: fullServicePath,
            .service: fullServicePath
        ]
    }

    func getBlackList() throws -> [String] {
        guard let blackList = model.blackList else {
            return []
        }
        let blackListFile: String = try Path(blackList).read()
        return blackListFile.split(separator: "\n").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    func getModelTypes() throws -> [ModelType] {
        guard let specifiedTypes = model.modelTypes else {
            throw SurfGenError(nested: ConfigManagerError.incorrectYamlFile,
                               message: "Could not get model types to generate")
        }
        return try specifiedTypes.map {
            switch GeneratedModelType(rawValue: $0) {
            case .nodeKitEntry?:
                return .entry
            case .nodeKitEntity?:
                return .entity
            case .enum?:
                return .enum
            case .none:
                throw SurfGenError(nested: ConfigManagerError.incorrectGenerationType,
                                   message: "Model type was not recognized")
            }
        }
    }

}
