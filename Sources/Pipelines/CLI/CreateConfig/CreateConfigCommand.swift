//
//  CreateConfigCommand.swift
//  
//
//  Created by Александр Кравченков on 13.10.2021.
//

import Foundation
import SwiftCLI
import Common

public final class CreateConfigCommand: Command {

    public enum ConfigType: String, ConvertibleFromString {
        case linter
        case generator
    }

    public let name: String = "create-config"
    public let shortDescription = "Create prefilled config file with all options"

    public let fileExtensionFlag = Key<String>(
        "--file-ext",
        "-f",
        description: "Value for property `fileExtension` in config"
    )

    public let typeFlag = Key<ConfigType>(
        "--type",
        "-t",
        description: "Type of config. Must be `linter` or `generator`"
    )

    public var loger: Loger = DefaultLogger.default

    public func execute() throws {

        guard let typeValue = self.typeFlag.value else {
            self.loger.fatal("--type paraeter wan't set")
            return
        }

        var configString = { () -> String in
            switch typeValue {
            case .generator: return ConfigTemplates.generator
            case .linter: return ConfigTemplates.linter
            }
        }()

        if let fileExt = self.fileExtensionFlag.value {
            configString = configString.replacingOccurrences(of: "${fileExtension}", with: fileExt)
        }

        try wrap(
            configString.write(toFile: ".surfgen.\(typeValue.rawValue).yaml", atomically: true, encoding: .utf8),
            message: "Couldn't write config into a file"
        )
    }

}


