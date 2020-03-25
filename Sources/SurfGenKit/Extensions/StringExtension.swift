//
//  StringExtension.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 31/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

extension String {

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

}
