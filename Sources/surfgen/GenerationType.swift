//
//  GenerationType.swift
//  
//
//  Created by Dmitry Demyanov on 07.11.2020.
//

enum GenerationType {
    case models([String])
    case service(String)

    var description: String {
        switch self {
        case .models(let modelNames):
            return "\(modelNames)"
        case .service(let serviceName):
            return serviceName
        }
    }

}
