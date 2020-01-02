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

