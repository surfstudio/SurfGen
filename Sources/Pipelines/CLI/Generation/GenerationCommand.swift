//
//  GenerationCommand.swift
//
//
//  Created by Dmitry Demyanov on 13.01.2021.
//

import Foundation
import SwiftCLI
import Yams
import Common
import Pipelines

public class GenerationCommand: Command {

    public let name: String = "generate"
    public let shortDescription = "Generate files with provided templates"

    public let serviceName = Key<String>("--name", "-n", description: "Name of service to generate")
    public let configPath = Key<String>("--config", "-c", description: "Path to config yaml-file")
    public let verbose = Flag("--verbose", "-v", description: "If set, will print debug-level logs")

    public var specPath = Parameter()

    public func execute() throws {
        let config = self.loadConfig()

        guard let serviceName = serviceName.value else {
            logger().fatal("Service name was not provided.")
            exit(-1)
        }

        let pipeline = BuildCodeGeneratorPipelineFactory.build(templates: config.templates,
                                                               serviceName: serviceName)

        guard let specUrl = URL(string: specPath.value) else {
            logger().fatal("Invalid path to root spec: \(specPath.value)")
            exit(-1)
        }

        do {
            try pipeline.run(with: specUrl)
            logger().success("All files generated successfully!")
        } catch {
            logger().fatal(error.localizedDescription)
            exit(-1)
        }
    }

    func logger() -> Logger {
        return self.verbose.value ? DefaultLogger.verbose : DefaultLogger.default
    }

    func loadConfig() -> GenerationConfig {
        guard let configPath = self.configPath.value else {
            logger().fatal("Config file was not provided.")
            exit(-1)
        }

        guard
            let data = FileManager.default.readFile(at: configPath),
            let yamlString =  String(data: data, encoding: .utf8)
        else {
            logger().fatal("Can't read config at \(configPath).")
            exit(-1)
        }

        do {
            let config: GenerationConfig = try YAMLDecoder().decode(from: yamlString)
            return config
        } catch {
            logger().fatal("Can't serialize config at \(configPath) as YAML with error \(error.localizedDescription).")
            exit(-1)
        }
    }

    func makeUrlsAbsolute(urls: [String]) throws -> Set<String> {
        let path = FileManager.default.currentDirectoryPath

        let result = try urls.map {
            try (path + $0).normalized()
        }

        return Set(result)
    }
}
