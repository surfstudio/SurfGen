//
//  Platform.swift
//  
//
//  Created by Dmitry Demyanov on 10.12.2020.
//

public enum Platform: String {
    case dart
    case kotlin
    case swift

    var fileExtension: String {
        switch self {
        case .dart, .swift:
            return rawValue
        case .kotlin:
            return "kt"
        }
    }

    var serviceParts: [ServicePart] {
        switch self {
        case .dart:
            return [.repository, .urlRoute]
        case .kotlin:
            return [.moduleDeclaration, .apiInterface, .repository, .urlRoute]
        case .swift:
            return [.service, .protocol, .urlRoute]
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
        case .dart, .kotlin:
            return ""
        case .swift:
            return "Entity"
        }
    }

    var entrySuffix: String {
        switch self {
        case .dart, .kotlin:
            return ""
        case .swift:
            return "Entry"
        }
    }

    var arrayLiteral: (start: String, end: String) {
        switch self {
        case .dart, .kotlin:
            return ("List<", ">")
        case .swift:
            return ("[", "]")
        }
    }

    var stringInterpolation: (start: String, end: String) {
        switch self {
        case .dart:
            return ("$", "")
        case .kotlin:
            return ("{", "}")
        case .swift:
            return ("\\(", ")")
        }
    }

    func constant(name: String) -> String {
        switch self {
        case .dart, .swift:
            return name.snakeCaseToCamelCase()
        case .kotlin:
            return name.uppercased()
        }
    }

    private var booleanType: String {
        switch self {
        case .dart:
            return "bool"
        case .kotlin:
            return "Boolean"
        case .swift:
            return "Bool"
        }
    }

    private var integerType: String {
        switch self {
        case .dart:
            return "int"
        case .kotlin, .swift:
            return "Int"
        }
    }

    private var numberType: String {
        switch self {
        case .dart:
            return "double"
        case .kotlin, .swift:
            return "Double"
        }
    }

    private var stringType: String {
        switch self {
        case .dart:
            return "String"
        case .kotlin, .swift:
            return "String"
        }
    }

}
