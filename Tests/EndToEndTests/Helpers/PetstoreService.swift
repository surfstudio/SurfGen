//
//  PetstoreService.swift
//  
//
//  Created by Dmitry Demyanov on 11.11.2020.
//

import SurfGenKit

enum PetstoreService: String, CaseIterable {
    case pet = "Pet"
    case store = "Store"
    case user = "User"
    
    private enum Constants {
        static let basePath = "TestFiles/"
    }

    func fileName(for servicePart: ServicePart) -> String {
        return servicePart.buildName(for: rawValue) + ".swift"
    }

    func getCode(for servicePart: ServicePart) -> String {
        return FileReader().readFile("\(filePath(for: servicePart)).txt")
    }

    private func filePath(for servicePart: ServicePart) -> String {
        return Constants.basePath + servicePart.buildName(for: rawValue)
    }

}
