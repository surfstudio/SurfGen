//
//  DefaultLogger.swift
//  
//
//  Created by Александр Кравченков on 07.01.2021.
//

import Foundation
import Rainbow

/// Default implementation of `Logger`
///
/// Prints each event to stdout.
///
/// Levels' colors:
/// `success` - `green`
/// `fatal` - `red` `bold`
/// `error` - `light red`
/// `warning` - `yeallow`
/// `info` - `white` `italic`
/// `debug` - `white` `bold`
///
/// This logger is based on `allow-list` implementation - so, you specify which level can be handled.
///
/// Contains some common implementation: `verbose` and `default`
public struct DefaultLogger: Logger {

    /// Will print all levels.
    public static var verbose: DefaultLogger {
        return .init(acceptedLevels: Set(CommonLogLevel.allCases))
    }

    /// Default logger
    ///
    /// Will print only
    /// - `error`
    /// - `fatal`
    /// - `info`
    /// - `success`
    /// - `warning`
    public static var `default`: DefaultLogger {
        return .init(acceptedLevels: [.error, .fatal, .info, .success, .warning])
    }

    public let acceptedLevels: Set<CommonLogLevel>

    public init(acceptedLevels: Set<CommonLogLevel>) {
        self.acceptedLevels = acceptedLevels
    }

    public func log(_ level: CommonLogLevel, _ msg: String) {

        guard acceptedLevels.contains(level) else {
            return
        }

        switch level {
        case .success:
            print(msg.green)
        case .fatal:
            print(msg.red.bold)
        case .error:
            print(msg.lightRed)
        case .warning:
            print(msg.yellow)
        case .info:
            print(msg.white.italic)
        case .debug:
            print(msg.white.bold)
        }
    }
}
