//
//  StringExtension.swift
//  
//
//  Created by Dmitry Demyanov on 17.10.2020.
//

extension String {

    func lowercaseFirstLetter() -> String {
        return prefix(1).lowercased() + dropFirst()
    }

    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    func pathToCamelCase() -> String {
        return self.split(whereSeparator: { $0 == "/" || $0 == "_" })
            .map { String($0) }
            .reduce("", { $0 + $1.capitalizingFirstLetter() })
            .lowercaseFirstLetter()
    }

}
