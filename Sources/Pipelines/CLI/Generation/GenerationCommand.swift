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
import Operations

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
                              description: "If set, existing files will be rewritten with new generated ones")

    public var specPath = Param<String>()

    public var loger: Loger = DefaultLogger.default

    public func execute() throws {

        let config = self.loadConfig()

        self.loger = self.initLoger(config: config)

        guard let serviceName = serviceName.value else {
            self.loger.fatal("Service name was not provided.")
            exit(-1)
        }

        if config.useNewNullableDeterminationStrategy == nil || config.useNewNullableDeterminationStrategy == false {
            loger.warning("Now you use old nullable determination strategy. We won't support this strategy in next major release. \nFor more detail look at https://github.com/surfstudio/SurfGen/blob/master/README.md#nullability")
        }

        var prefixCutter: PrefixCutter?

        if let masks = config.prefixesToCutDownInServiceNames, !masks.isEmpty {
            prefixCutter = PrefixCutter(prefixesToCut: Set(masks))
        }

        var rawAstNodesToExclude = config.exludedNodes ?? []

        Utils.Urls.validateAstNodePathesAndExistIfError(pathes: rawAstNodesToExclude, loger: self.loger)

        rawAstNodesToExclude = Utils.Urls.addForwardingSlashIfNeeded(urls: rawAstNodesToExclude)

        let pipeline = BuildCodeGeneratorPipelineFactory.build(
            templates: config.templates,
            specificationRootPath: config.specificationRootPath ?? "",
            astNodesToExclude: try Utils.Urls.makeAstNodeRefsAbsolute(refs: rawAstNodesToExclude),
            serviceName: serviceName,
            needRewriteExistingFiles: rewrite.value,
            useNewNullableDefinitionStartegy: config.useNewNullableDeterminationStrategy ?? false,
            prefixCutter: prefixCutter,
            logger: self.loger
        )

        let path = try Utils.Urls.makeUrlAbsoluteIfNeeded(url: specPath.value)

        guard let specUrl = URL(string: path) else {
            self.loger.fatal("Invalid path to root spec: \(path)")
            exit(-1)
        }

        do {
            try pipeline.run(with: specUrl)
            self.loger.success("All files generated successfully!")
        } catch {
            self.loger.fatal(error.localizedDescription)
            exit(-1)
        }
    }

    func initLoger(config: GenerationConfig) -> Loger {

        CommonError.saveDebugInfo = self.verbose.value

        let stdioLoger = self.verbose.value ? DefaultLogger.verbose : DefaultLogger.default

        guard let analytics = self.initAnalyticsClientIfPossible(config: config) else {
            return stdioLoger
        }

        return AnalyticsSenderLoger(stdioLogger: stdioLoger,
                                    analyticsClient: analytics,
                                    initCmdCommandRaw: CommandLine.arguments.joined(separator: " "))
    }

    func loadConfig() -> GenerationConfig {
        guard let configPath = self.configPath.value else {
            self.loger.fatal("Config file was not provided.")
            exit(-1)
        }

        guard
            let data = FileManager.default.readFile(at: configPath),
            let yamlString =  String(data: data, encoding: .utf8)
        else {
            self.loger.fatal("Can't read config at \(configPath).")
            exit(-1)
        }

        do {
            let config: GenerationConfig = try YAMLDecoder().decode(from: yamlString)
            return config
        } catch {
            self.loger.fatal("Can't serialize config at \(configPath) as YAML with error \(error.localizedDescription).")
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

        guard let analytcsConfig = config.analytcsConfig else {
            self.loger.info("Analytics config is empty")
            return nil
        }

        guard let logstashEndpointURI = URL(string: analytcsConfig.logstashEnpointURI) else {
            self.loger.error("An error occured while creating URI from logstashEnpointURI \(analytcsConfig.logstashEnpointURI)")
            return nil
        }

        return LogstashHttpClient(endpointUri: logstashEndpointURI, payload: analytcsConfig.payload ?? [:])
    }
}
