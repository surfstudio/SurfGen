//
//  CustomError.swift
//
//
//  Created by Александр Кравченков on 12.12.2020.
//

import Foundation

public struct CustomError: LocalizedError {
    var message: String
    var line: Int
    var function: String
    var column: Int

    public init(message: String, line: Int = #line, function: String = #function, column: Int = #column) {
        self.message = message
        self.line = line
        self.function = function
        self.column = column
    }

    public var errorDescription: String? {
        var msg = "❌ Error!"
        msg += "\n"
        msg += "Message: \(self.message)"
        msg += "\n"
        msg += "Debug info:"
        msg += "\n\t"
        msg += "function: \(self.function)"
        msg += "\n\t"
        msg += "line: \(self.line)"
        msg += "\n\t"
        msg += "Column: \(self.column)"
        return msg
    }
}
