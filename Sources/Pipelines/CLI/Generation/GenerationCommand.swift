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
import AnalyticsClient

public class GenerationCommand: Command {

    public let name: String = "generate"
    public let shortDescription = "Generate files with provided templates"

    public let serviceName = Key<String>("--name",
                                         "-n",
                                         description: "Name of service to generate")

    public let configPath = Key<String>("--config",
                                        "-c",
                                        description: "Path to config yaml-file")

    public let verbose = Flag("--verbose",
                              "-v",
                              description: "If set, will print debug-level logs")

    public let rewrite = Flag("--rewrite",
                              "-r",
                              description: "If set, existing files will be rewritten with new generated ones",
                              defaultValue: false)

    public var specPath = Parameter()

    public func execute() throws {
        let config = self.loadConfig()

        let analytics = self.initAnalyticsClientIfPossible(config: config)

        var defaultPayload = [
            "commandName": self.name,
            "serviceName": self.serviceName,
            "configPath": self.configPath,
            "verbose": self.verbose,
            "rewrite": self.rewrite,
            "specPath": self.specPath.value
        ] as [String : Any]

        guard let serviceName = serviceName.value else {
            logger().fatal("Service name was not provided.")
            defaultPayload["Result"] = "Error"
            defaultPayload["Error"] = "Service name was not provided."
            try analytics?.logEvent(payload: defaultPayload)
            exit(-1)
        }

        let pipeline = BuildCodeGeneratorPipelineFactory.build(templates: config.templates,
                                                               serviceName: serviceName,
                                                               needRewriteExistingFiles: rewrite.value,
                                                               logger: logger())

        guard let specUrl = URL(string: specPath.value) else {
            logger().fatal("Invalid path to root spec: \(specPath.value)")
            defaultPayload["Result"] = "Error"
            defaultPayload["Error"] = "Invalid path to root spec: \(specPath.value)"
            try analytics?.logEvent(payload: defaultPayload)
            exit(-1)
        }

        do {
            try pipeline.run(with: specUrl)
            logger().success("All files generated successfully!")
            defaultPayload["Result"] = "OK"
            try? analytics?.logEvent(payload: defaultPayload)
        } catch {
            logger().fatal(error.localizedDescription)
            defaultPayload["Result"] = "Error"
            defaultPayload["Error"] = error.localizedDescription
            try analytics?.logEvent(payload: defaultPayload)
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

    func initAnalyticsClientIfPossible(config: GenerationConfig) -> AnalyticsClient? {

        guard let logstashEnpoint = config.logstashEnpointURI else {
            logger().info("Logstash enpoint URL is empty. Analytics won't be sent")
            return nil
        }

        guard let logstashEndpointURI = URL(string: logstashEnpoint) else {
            logger().error("An error occured while creating URI from logstashEnpointURI \(logstashEnpoint)")
            return nil
        }

        return LogstashHttpClient(enpointUri: logstashEndpointURI)
    }
}
