//
//  File.swift
//  
//
//  Created by Александр Кравченков on 13.12.2020.
//

import Foundation

public enum Referenced<Nested> {
    case entity(Nested)
    case ref(String)
}

extension Referenced: StringView where Nested: StringView {
    public var view: String {
        switch self {
        case .entity(let nested):
            return nested.view
        case .ref(let ref):
            return "$ref: \(ref)"
        }
    }
}
