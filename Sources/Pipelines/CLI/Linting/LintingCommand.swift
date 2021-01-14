//
//  LintingCommand.swift
//  
//
//  Created by Александр Кравченков on 07.01.2021.
//

import Foundation
import SwiftCLI
import Yams
import Common
import Pipelines

public class LintingCommend: Command {

    public let name: String = "lint"
    public let shortDescription = "Check that api specification is correct (in terms of SurfGen) and ready for code generation"

    public let configPath = Key<String>("--config", "-c", description: "Path to config yaml-file")
    public let verbose = Flag("--verbose", "-v", description: "If set, will print debug-level logs")

    public var pathToLint = Parameter()

    public func execute() throws {
        let config = self.loadConfig()
        let pipeline = BuildLinterPipelineFactory.build(
            filesToIgnore: try self.makeUrlsAbsolute(urls: config.exclude),
            log: self.logger()
        )

        do {
            try pipeline.run(with: pathToLint.value)
            logger().success("All right!!! Good Job!")
        } catch {
            logger().fatal(error.localizedDescription)
            exit(-1)
        }
    }

    func logger() -> Logger {
        return self.verbose.value ? DefaultLogger.verbose : DefaultLogger.default
    }

    func loadConfig() -> LintingConfig {
        guard let configPath = self.configPath.value else {
            return .init(exclude: [])
        }

        guard
            let data = FileManager.default.readFile(at: configPath),
            let yamlString =  String(data: data, encoding: .utf8)
        else {
            DefaultLogger.default.error("Can't read config at \(configPath). SurfGen will continue with empty config")
            return .init(exclude: [])
        }

        do {
            let config: LintingConfig = try YAMLDecoder().decode(from: yamlString)
            return config
        } catch {
            DefaultLogger.default.error("Can't serialize config at \(configPath) as YAML with error \(error.localizedDescription). SurfGen will continue with empty config")
        }

        return .init(exclude: [])
    }

    func makeUrlsAbsolute(urls: [String]) throws -> Set<String> {
        let path = FileManager.default.currentDirectoryPath

        let result = try urls.map {
            try (path + $0).normalized()
        }

        return Set(result)
    }
}
