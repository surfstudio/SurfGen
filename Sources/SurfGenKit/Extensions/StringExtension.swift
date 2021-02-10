//
//  StringExtension.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 31/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

extension String {

    func asArray(platform: Platform) -> String {
        return platform.arrayLiteral.start + self + platform.arrayLiteral.end
    }

    func plainType(for platform: Platform) -> String? {
        guard let plainType = PlainType(rawValue: self) else {
            return nil
        }
        return platform.plainType(type: plainType)
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

    func withFileExtension(_ ext: String) -> String {
        return "\(self).\(ext)"
    }

    func operationName(with method: String, rootPath: String) -> String {
        guard self.pathPartsCount > 1 else {
            return method + self
            .replacingOccurrences(of: "[{}]", with: "", options: .regularExpression)
            .pathToCamelCase()
            .capitalizingFirstLetter()
        }

        let camelRootPath = rootPath.pathToCamelCase().capitalizingFirstLetter()
    
        return method + self
            .replacingOccurrences(of: "[{}]", with: "", options: .regularExpression)
            .split(separator: "/")
            .map { String($0) }
            .reduce("", { $0 + $1.capitalizingFirstLetter() })
            .snakeCaseToCamelCase()
            .capitalizingFirstLetter()
            .replacingOccurrences(of: camelRootPath, with: "")
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

    func pathWithParameterInterpolation(platform: Platform) -> String {
        return self
            .replacingOccurrences(of: "{", with: platform.stringInterpolation.start)
            .replacingOccurrences(of: "}", with: platform.stringInterpolation.end)
    }

    func snakeCaseToCamelCase() -> String {
        return self.split(separator: "_")
            .map { String($0) }
            .reduce("", { $0 + $1.capitalizingFirstLetter() })
            .lowercaseFirstLetter()
    }

    func tabShifted() -> String {
        return self.replacingOccurrences(of: "\n", with: "\n\t")
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
