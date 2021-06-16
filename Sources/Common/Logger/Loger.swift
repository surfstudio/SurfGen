//
//  Logger.swift
//  
//
//  Created by Александр Кравченков on 07.01.2021.
//

import Foundation

/// Contains default logging levels.
public enum CommonLogLevel: CaseIterable {
    /// Use it when you need to tell users that operation ended successfully.
    case success
    /// Use it to show fatal errors. After this errors executing will be interrupted.
    case fatal
    /// Use it to tell about non-critical errors.
    case error
    /// Use it to tell about some issues.
    case warning
    /// Use it to tell some generic information. May be to give some advice.
    case info
    /// Use it to show debug information in runtime
    case debug
}

extension CommonLogLevel {
    /// Returns string representation of log level
    /// Useful for serialization
    public var stringValue: String {
        switch self {
        case .success:
            return "success"
        case .fatal:
            return "fatal"
        case .error:
            return "error"
        case .warning:
            return "warning"
        case .info:
            return "info"
        case .debug:
            return "debug"
        }
    }
}

/// Interface for any logger
public protocol Loger {
    /// Write information to output stream, which is spicified in specific `Logger` implementation
    ///
    /// You also can log in short notation. Like `log.success("Some msg")`
    func log(_ level: CommonLogLevel, _ msg: String)
}


/// Contains inline omplementation of logging for each `CommonLogLevel` case.
extension Loger {
    public func success(_ msg: String) {
        self.log(.success, msg)
    }

    public func fatal(_ msg: String) {
        self.log(.fatal, msg)
    }

    public func error(_ msg: String) {
        self.log(.error, msg)
    }

    public func warning(_ msg: String) {
        self.log(.warning, msg)
    }

    public func info(_ msg: String) {
        self.log(.info, msg)
    }

    public func debug(_ msg: String) {
        self.log(.debug, msg)
    }
}
