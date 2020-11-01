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

    var name: String {
        switch self {
        case .urlRoute:
            return "UrlRoute"
        case .protocol:
            return "Service"
        case .service:
            return "NetworkService"
        }
    }

    func form(name value: String) -> String {
        return "\(value)\(name)"
    }

}
