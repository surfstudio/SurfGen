//
//  ModelsType.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 09/11/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public enum ModelType {
    case entity
    case entry
    
    var name: String {
        switch self {
        case .entity:
            return "Entity"
        case .entry:
            return "Entry"
        }
    }

    func formName(with value: String) -> String {
        return "\(value)\(name)"
    }

}

extension String {

    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }

    var withSwiftExt: String {
        return self + ".swift"
    }

    func snakeCaseToCamelCase() -> String {
        let buf: NSString = self.capitalized.replacingOccurrences(of: "(\\w{0,1})_",
                                                                  with: "$1",
                                                                  options: .regularExpression,
                                                                  range: nil) as NSString
        return buf.replacingCharacters(in: NSMakeRange(0,1), with: buf.substring(to: 1).lowercased()) as String
    }

}

