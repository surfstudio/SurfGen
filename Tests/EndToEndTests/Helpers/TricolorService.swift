//
//  TricolorService.swift
//  
//
//  Created by Dmitry Demyanov on 21.11.2020.
//

import SurfGenKit

enum TricolorService: String, CaseIterable {
    case activation
    case auth
    case billings
    case catalog
    case command
    case feedback
    case help
    case history
    case messages
    case payment
    case profile
    case promotions
    case push
    case united
    case user
    
    private enum Constants {
        static let basePath = "TestFiles/Tricolor/"
    }

    static var passingGenerationCases: [Self] {
        return [activation, auth, billings, command, feedback, help, payment, profile, push, united, user]
    }

    static var externalParametersCases: [Self] {
        return [history, messages, promotions]
    }

    var rootPath: String {
        switch self {
        case .activation, .auth, .billings, .command, .feedback, .messages, .promotions, .user, .united:
            return rawValue
        case .catalog:
            return "billings"
        case .help:
            return "feedback"
        case .history:
            return "billings"
        case .payment:
            return "billings"
        case .profile:
            return "userProfile"
        case .push:
            return "user"
        }
    }

    var specPath: String {
        return Constants.basePath + "specs/\(rawValue).yaml"
    }

    func fileName(for servicePart: ServicePart) -> String {
        return servicePart.buildName(for: rawValue.capitalizingFirstLetter()) + ".swift"
    }

    func getCode(for servicePart: ServicePart) -> String {
        return FileReader().readFile("\(filePath(for: servicePart)).txt")
    }

    private func filePath(for servicePart: ServicePart) -> String {
        return Constants.basePath + servicePart.buildName(for: rawValue.capitalizingFirstLetter())
    }

}

private extension String {

    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

}

