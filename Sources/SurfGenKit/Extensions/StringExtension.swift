//
//  StringExtension.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 31/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

extension String {

    func asArray() -> String {
        return "[\(self)]"
    }

    func formOptional(_ isOptional: Bool) -> String {
        return self + isOptional.asOptionalSign
    }

    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    func lowercaseFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

    var withSwiftExt: String {
        return self + ".swift"
    }

    func operationName(forService serviceName: String, with method: String) -> String {
            guard self.pathPartsCount > 1 else {
                return method + self
                .replacingOccurrences(of: "[{}]", with: "", options: .regularExpression)
                .pathToCamelCase()
                .capitalizingFirstLetter()
            }
            return method + self
                .replacingOccurrences(of: "[{}]", with: "", options: .regularExpression)
                .split(separator: "/")
                .map { String($0) }
                .reduce("", { $0 + $1.capitalizingFirstLetter() })
                .snakeCaseToCamelCase()
                .capitalizingFirstLetter()
                .replacingOccurrences(of: serviceName, with: "")
        }

    var pathName: String {
        guard self.pathPartsCount > 1 else {
            return self
                .replacingOccurrences(of: "[{}]", with: "", options: .regularExpression)
                .pathToCamelCase()
        }
        return self
            .replacingOccurrences(of: "[{}]", with: "", options: .regularExpression)
            .split(separator: "/")
            .map { String($0) }
            .removingFirst()
            .reduce("", { $0 + $1.capitalizingFirstLetter() })
            .snakeCaseToCamelCase()
    }

    func pathToCamelCase() -> String {
        return self.split(whereSeparator: { $0 == "/" || $0 == "_" })
            .map { String($0) }
            .reduce("", { $0 + $1.capitalizingFirstLetter() })
            .lowercaseFirstLetter()
    }

    func pathWithSwiftParameters() -> String {
        return self
            .replacingOccurrences(of: "{", with: "\\(")
            .replacingOccurrences(of: "}", with: ")")
    }

    func snakeCaseToCamelCase() -> String {
        return self.split(separator: "_")
            .map { String($0) }
            .reduce("", { $0 + $1.capitalizingFirstLetter() })
            .lowercaseFirstLetter()
    }

    /// index for default model properties order
    var propertyPriorityIndex: Int {
        switch self {
        case "id":
            return 10
        case "name":
            return 9
        case "type":
            return 8
        default:
            return 0
        }
    }

    private var pathPartsCount: Int {
        return self
            .split(separator: "/")
            .map { String($0) }
            .filter { !$0.contains("{") }
            .count
    }

}
