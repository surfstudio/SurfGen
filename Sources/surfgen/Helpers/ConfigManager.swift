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

    var generationPathes: [ModelType: String] {
        return [
            .entity: model.entitiesPath,
            .entry: model.entriesPath,
            .enum: model.enumPath
        ]
    }

    var tempatePath: Path {
        return Path(model.tempatesPath)
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

    // MARK: - Private Properties

    private let model: ConfigModel

    // MARK: - Initialization

    init(path: Path) throws {
        let config: String = try path.read()
        let decoder = YAMLDecoder()
        self.model = try decoder.decode(ConfigModel.self, from: config)
    }

    // MARK: - Internal methods

    func getBlackList() throws -> [String] {
        guard let blackList = model.blackList else {
            return []
        }
        let blackListFile: String = try Path(blackList).read()
        return blackListFile.split(separator: "\n").map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
    }

    func getGenerationTypes() throws -> [ModelType] {
        return try model.generationTypes.map {
            switch GeneratedModelType(rawValue: $0) {
            case .nodeKitEntry?:
                return .entry
            case .nodeKitEntity?:
                return .entity
            case .enum?:
                return .enum
            case .none:
                throw ConfigManagerError.incorrectGenerationType
            }
        }
    }

}
