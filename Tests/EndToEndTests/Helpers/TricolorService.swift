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
//    case help
    case history
    case messages
//    case payment
    case profile
    case promotions
//    case push
//    case united
    case user
    
    private enum Constants {
        static let basePath = "TestFiles/Tricolor/"
    }

    static var passingGenerationCases: [Self] {
        return [activation, auth, billings, command, feedback, profile, user]
    }

    static var externalParametersCases: [Self] {
        return [history, messages, promotions]
    }

    var serviceName: String {
        switch self {
        case .activation:
            return "Activation"
        case .auth:
            return "Auth"
        case .billings:
            return "Billings"
        case .catalog:
            return "Billings"
        case .command:
            return "Command"
        case .feedback:
            return "Feedback"
        case .history:
            return "Billings"
        case .messages:
            return "Messages"
        case .profile:
            return "UserProfile"
        case .promotions:
            return "Promotions"
        case .user:
            return "User"
        }
    }

    var specPath: String {
        return Constants.basePath + "specs/\(rawValue).yaml"
    }

    func fileName(for servicePart: ServicePart) -> String {
        return servicePart.buildName(for: serviceName) + ".swift"
    }

    func getCode(for servicePart: ServicePart) -> String {
        return FileReader().readFile("\(filePath(for: servicePart)).txt")
    }

    private func filePath(for servicePart: ServicePart) -> String {
        return Constants.basePath + servicePart.buildName(for: serviceName)
    }

}

