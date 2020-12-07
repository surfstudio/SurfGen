//
//  ServicePart.swift
//  
//
//  Created by Dmitry Demyanov on 30.10.2020.
//

public enum ServicePart: CaseIterable {
    case urlRoute
    case `protocol`
    case service

    private var partName: String {
        switch self {
        case .urlRoute:
            return "UrlRoute"
        case .protocol:
            return "Service"
        case .service:
            return "NetworkService"
        }
    }

    public func buildName(for service: String) -> String {
        return "\(service)\(partName)"
    }

}
