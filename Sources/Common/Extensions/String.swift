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
        return self.split(separator: "_")
            .map { String($0) }
            .reduce("", { $0 + $1.capitalizingFirstLetter() })
            .lowercaseFirstLetter()
    }

    private func pathToCamelCase() -> String {
        return self.split(whereSeparator: { $0 == "/" || $0 == "_" })
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
