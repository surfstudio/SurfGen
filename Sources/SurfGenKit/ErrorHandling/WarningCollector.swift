//
//  WarningCollector.swift
//  
//
//  Created by Dmitry Demyanov on 28.11.2020.
//

enum Warning {
    case unsupportedRequestEncoding(String, String)
    case complexObjectResponseBody(String)
    case undefinedModelResponseBody(String)

    var description: String {
        switch self {
        case .unsupportedRequestEncoding(let operationName, let encodingDescription):
            return "Operation \(operationName) has unsupported encoding: \(encodingDescription).\n"
                + "Method body was not generated."
        case .complexObjectResponseBody(let operationName):
            return "Operation \(operationName) response body is a complex object."
                + "\nResponse model name was not generated."
        case .undefinedModelResponseBody(let operationName):
            return "Operation \(operationName) response body can be one of multiple models."
                + "\nResponse model name was not generated."
        }
    }

}

class WarningCollector {

    private var warnings = [Warning]()

    static let shared = WarningCollector()

    var reportLog: String {
        return "Generation finished with warnings:\n\n" + warnings
            .map { $0.description }
            .joined(separator: "\n\n")
    }

    var isEmpty: Bool {
        return warnings.isEmpty
    }

    func add(warning: Warning) {
        warnings.append(warning)
    }

}
