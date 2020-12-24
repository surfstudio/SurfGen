//
//  ServicePart.swift
//  
//
//  Created by Dmitry Demyanov on 30.10.2020.
//

public enum ServicePart: String {
    case urlRoute
    case `protocol`
    case service
    case moduleDeclaration
    case apiInterface
    case repository
    
    private func partName(for platform: Platform) -> String {
        switch self {
        case .urlRoute:
            return platform == .swift ? "UrlRoute" : "Urls"
        case .protocol:
            return "Service"
        case .service:
            return "NetworkService"
        case .moduleDeclaration:
            return "Module"
        case .apiInterface:
            return "Api"
        case .repository:
            return "Repository"
        }
    }

    public func buildName(for service: String, platform: Platform) -> String {
        return "\(service)\(partName(for: platform))"
    }

    func templateName(for platform: Platform) -> String {
        return partName(for: platform) + ".txt"
    }

}
