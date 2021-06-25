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
import AnalyticsClient

public class LintingCommand: Command {

    public var loger: Loger = DefaultLogger.default

    public let name: String = "lint"
    public let shortDescription = "Check that api specification is correct (in terms of SurfGen) and ready for code generation"

    public let configPath = Key<String>("--config", "-c", description: "Path to config yaml-file")
    public let verbose = Flag("--verbose", "-v", description: "If set, will print debug-level logs")

    public var pathToLint = Parameter()

    public func execute() throws {
        let config = self.loadConfig()

        self.loger = self.initLoger(config: config)

        let pipeline = BuildLinterPipelineFactory.build(
            filesToIgnore: try self.makeUrlsAbsolute(urls: config.exclude),
            log: self.loger
        )

        do {
            try pipeline.run(with: pathToLint.value)
            self.loger.success("All right!!! Good Job!")
        } catch {
            self.loger.fatal(error.localizedDescription)
            exit(-1)
        }
    }

    func loadConfig() -> LintingConfig {
        guard let configPath = self.configPath.value else {
            return .init(exclude: [])
        }

        guard
            let data = FileManager.default.readFile(at: configPath),
            let yamlString =  String(data: data, encoding: .utf8)
        else {
            self.loger.error("Can't read config at \(configPath). SurfGen will continue with empty config")
            return .init(exclude: [])
        }

        do {
            let config: LintingConfig = try YAMLDecoder().decode(from: yamlString)
            return config
        } catch {
            self.loger.error("Can't serialize config at \(configPath) as YAML with error \(error.localizedDescription). SurfGen will continue with empty config")
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

private extension LintingCommand {

    func initLoger(config: LintingConfig) -> Loger {

        CommonError.saveDebugInfo = self.verbose.value

        let stdioLoger = self.verbose.value ? DefaultLogger.verbose : DefaultLogger.default

        guard let analytics = self.initAnalyticsClientIfPossible(config: config) else {
            return stdioLoger
        }

        return AnalyticsSenderLoger(stdioLogger: stdioLoger,
                                    analyticsClient: analytics,
                                    initCmdCommandRaw: CommandLine.arguments.joined(separator: " "))
    }
    
    func initAnalyticsClientIfPossible(config: LintingConfig) -> AnalyticsClient? {

        guard let analytcsConfig = config.analytcsConfig else {
            self.loger.info("Analytics config is empty")
            return nil
        }

        guard let logstashEndpointURI = URL(string: analytcsConfig.logstashEnpointURI) else {
            self.loger.error("An error occured while creating URI from logstashEnpointURI \(analytcsConfig.logstashEnpointURI)")
            return nil
        }

        return LogstashHttpClient(enpointUri: logstashEndpointURI, payload: analytcsConfig.payload ?? [:])
    }
}
