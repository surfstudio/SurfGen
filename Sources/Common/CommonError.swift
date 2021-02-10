//
//  CommonError.swift
//
//
//  Created by Александр Кравченков on 12.12.2020.
//

import Foundation

/// Must be used Error
/// Contains meta information about error
/// whis is useful for debugging and understading in `What was happen?!`
///
/// Must be used in all cases except some specific sutuations
/// To print error information you need to call `errorDescription`
///
/// Contains factory of `stub errors`
public struct CommonError: LocalizedError {
    /// Message for user. This mesage should explain `What was happen` clearly (for junior developer)
    let message: String
    /// Line of code where error was occured.
    /// Filled automatically
    let line: Int
    /// function name where error was occured.
    /// Filled automatically
    let function: String
    /// Column if line of code where error was occured.
    /// Filled automatically
    let column: Int
    /// File path where error was occured.
    /// Filled automatically
    let file: String
    /// Call stack. Contains calls which was occured befor error throwing.
    /// Filled automatically
    let stack: [String]

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
        // first 3 elements it's just a main calling
        // and the last 3 it's this funciton calling
        self.stack = [String](Thread.callStackSymbols.dropFirst(3).dropFirst(3))
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
        msg += "\n\t"
        msg += "Call Stack: \(self.stack.reduce(into: "", { $0 += "\n\t\($1)" }))"
        return msg
    }
}

extension CommonError {

    /// Factory of `notImplemented` stub.
    /// Use in all cases where you want to write `TODO: ..`
    ///
    /// For example. If you create method:
    ///
    /// ```Swift
    /// func doSmth(param: SomeParams) throws -> SomeData {
    ///     ....
    /// }
    ///```
    /// Then if you try to compile this code you will get compilation error
    /// because method doesn't have a `return` expression. So:
    ///
    /// ```Swift
    /// func doSmth(param: SomeParams) throws -> SomeData {
    ///     return .init(param: "", param2: 1...)
    /// }
    ///```
    /// **BUT DON"T DO IT**
    ///
    /// **DONT WRITE STUB IMPLEMENTATION**
    ///
    /// Instead, write:
    ///
    /// ```Swift
    /// func doSmth(param: SomeParams) throws -> SomeData {
    ///     throws CommonError.notInplemented()
    /// }
    ///
    /// ```
    ///
    /// And then you can continue writing code, tests and so on
    /// And when execution will call your code
    /// Your tests will crash with error.
    public static func notInplemented(line: Int = #line,
                                      function: String = #function,
                                      column: Int = #column,
                                      file: String = #file) -> CommonError {
        return CommonError(message: "NOT IMPLEMENTED!!!", line: line, function: function, column: column, file: file)
    }
}
