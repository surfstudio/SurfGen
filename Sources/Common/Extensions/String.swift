//
//  String.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation

extension String {

    /// Shift each `\n` on one `\t`
    public func tabShifted() -> String {
        return self.replacingOccurrences(of: "\n", with: "\n\t")
    }

    /// Get path name from path URI template
    /// Example: /banners/{location} -> bannersLocation
    public var pathName: String {
        guard self.pathPartsCount > 1 else {
            return self
                .replacingOccurrences(of: "[{}]", with: "", options: .regularExpression)
                .pathToCamelCase()
        }
        return self
            .replacingOccurrences(of: "[{}]", with: "", options: .regularExpression)
            .split(separator: "/")
            .map { String($0) }
            .dropFirst()
            .reduce("", { $0 + $1.capitalizingFirstLetter() })
            .snakeCaseToCamelCase()
    }

    /// Get path with separated parameters from path URI template
    /// Example: /banners/{location} -> banners" + location + "
    /// Note: String interpolation would look nicer than just adding strings, but it's platform dependent
    public var pathWithSeparatedParameters: String {
        return self
            .replacingOccurrences(of: "{", with: "\" + ")
            .replacingOccurrences(of: "}", with: " + \"")
    }

    public var isSuccessStatusCode: Bool {
        return self.hasPrefix("2") && self.count == 3
    }

    public func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    public func lowercaseFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }

    /// Turns snake_case into camelCase
    public func snakeCaseToCamelCase() -> String {
        return self
            .split(separator: "_")
            .map { String($0) }
            .reduce("", { $0 + $1.capitalizingFirstLetter() })
            .lowercaseFirstLetter()
    }

    /// Firstly check that this string contains only uppercased characters
    /// If it is - call `upperCaseToCamelCase()`
    /// If it isn't - return this string without changes - useful for chaining different operators without explicit conditions
    public func upperCaseToCamelCaseOrSelf() -> Self {

        let letters = self.replacingOccurrences(of: "_", with: "")

        let checkResult = letters.allSatisfy { c in
            c.isUppercase
        }

        guard checkResult else {
            return self
        }

        return upperCaseToCamelCase()
    }


    /// Transforms UpperCased string to lower CamelCased
    /// For example:
    /// FIRST_SECOND_THRID -> firstSecondThird
    /// - seeAlso: `upperCaseToCamelCaseOrSelf()`
    public func upperCaseToCamelCase() -> String {

        // FIRST_SECOND_THIRD -> FIRST + SECOND + THIRD
        let separated = self.split(separator: "_")

        // if after separation we have empty array then we have to return somethis which looks like error :D
        guard let first = separated.first else {
            return "!!!!! SOMETHING WENT WRONG WITH \(#function) string is empty"
        }

        // Take first part and make it lowercased
        // FIRST -> first (to make firstSecondThird later)

        let firstLowercased = first.lowercased()

        // other elements should be lowercased with first capitalized letter
        // SECOND + THIRD -> Second + Third
        var other = separated.dropFirst().map { $0.lowercased().capitalizingFirstLetter() }

        // make first + Second + Third
        other.insert(firstLowercased, at: 0)

        return other.joined()
    }

    /// Turns camelCase into snake_case
    public func camelCaseToSnakeCase() -> String {
        return self
            .replacingOccurrences(of: "(?<!^)(?=[A-Z])", with: "_", options: .regularExpression)
            .lowercased()
    }

    public func replaceNameTemplate(with name: String) -> String {
        return self.replacingOccurrences(of: "\\{.*?\\}", with: name, options: .regularExpression)
    }

    private func pathToCamelCase() -> String {
        return self
            .split(whereSeparator: { $0 == "/" || $0 == "_" })
            .map { String($0) }
            .reduce("", { $0 + $1.capitalizingFirstLetter() })
            .lowercaseFirstLetter()
    }

    private var pathPartsCount: Int {
        return self
            .split(separator: "/")
            .map { String($0) }
            .filter { !$0.contains("{") }
            .count
    }
}
