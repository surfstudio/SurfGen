//
//  File.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation

public protocol StringView {
    var view: String { get }
}

extension String: StringView {
    public var view: String {
        return self
    }
}

extension Array where Element: StringView {
    public var view: String {
        var result = ""

        self.forEach { item in
            result += "- "
            result += item.view
            result += "\n\t"
        }

        return result
    }
}
