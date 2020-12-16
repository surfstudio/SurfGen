//
//  Platform.swift
//  
//
//  Created by Dmitry Demyanov on 10.12.2020.
//

public enum Platform: String {
    case dart
    case swift

    var fileExtension: String {
        return rawValue
    }

    var voidType: String {
        switch self {
        case .dart:
            return "void"
        case .swift:
            return "Void"
        }
    }

    func plainType(type: PlainType) -> String {
        switch type {
        case .boolean:
            return booleanType
        case .integer:
            return integerType
        case .number:
            return numberType
        case .string:
            return stringType
        }
    }

    var entitySuffix: String {
        switch self {
        case .dart:
            return ""
        case .swift:
            return "Entity"
        }
    }

    var entrySuffix: String {
        switch self {
        case .dart:
            return ""
        case .swift:
            return "Entry"
        }
    }

    var arrayLiteral: (start: String, end: String) {
        switch self {
        case .dart:
            return ("List<", ">")
        case .swift:
            return ("[", "]")
        }
    }

    var stringInterpolation: (start: String, end: String) {
        switch self {
        case .dart:
            return ("$", "")
        case .swift:
            return ("\\(", ")")
        }
    }

    private var booleanType: String {
        switch self {
        case .dart:
            return "bool"
        case .swift:
            return "Bool"
        }
    }

    private var integerType: String {
        switch self {
        case .dart:
            return "int"
        case .swift:
            return "Int"
        }
    }

    private var numberType: String {
        switch self {
        case .dart:
            return "double"
        case .swift:
            return "Double"
        }
    }

    private var stringType: String {
        switch self {
        case .dart:
            return "String"
        case .swift:
            return "String"
        }
    }

}
