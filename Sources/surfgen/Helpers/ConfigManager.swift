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
        return [
            .entity: model.entitiesPath,
            .entry: model.entriesPath,
            .enum: model.enumPath
        ].compactMapValues { $0 }
    }

    func getServiceGenerationPaths(for serviceName: String) throws -> [ServicePart: String] {
        return [
            .urlRoute: model.endpointsPath?.filePathInserting(name: serviceName.capitalizingFirstLetter()),
            .protocol: model.servicesPath?.filePathInserting(name: serviceName.capitalizingFirstLetter()),
            .service: model.servicesPath?.filePathInserting(name: serviceName.capitalizingFirstLetter()),
            .apiInterface: model.apiInterfacePath?.filePathInserting(name: serviceName.capitalizingFirstLetter()),
            .moduleDeclaration: model.modulePath?.filePathInserting(name: serviceName.capitalizingFirstLetter()),
            .repository: model.repositoryPath?.filePathInserting(name: serviceName.capitalizingFirstLetter())
        ].compactMapValues { $0 }
    }

    func getBlackList() throws -> [String] {
        guard let blackList = model.blackList else {
            return []
        }
        let blackListFile: String = try Path(blackList).read()
        return blackListFile.split(separator: "\n").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
    }

}
