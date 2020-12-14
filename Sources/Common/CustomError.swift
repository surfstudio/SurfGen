//
//  CustomError.swift
//
//
//  Created by Александр Кравченков on 12.12.2020.
//

import Foundation

public struct CustomError: LocalizedError {
    let message: String
    let line: Int
    let function: String
    let column: Int
    let file: String

    public init(message: String,
                line: Int = #line,
                function: String = #function,
                column: Int = #column,
                file: String = #file) {
        self.message = message
        self.line = line
        self.function = function
        self.column = column
        self.file = file
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
        msg += "\n\t"
        msg += "File: \(self.file)"
        return msg
    }
}

extension CustomError {
    public static func notInplemented(line: Int = #line,
                                      function: String = #function,
                                      column: Int = #column,
                                      file: String = #file) -> CustomError {
        return CustomError(message: "NOT IMPLEMENTED!!!", line: line, function: function, column: column, file: file)
    }
}
