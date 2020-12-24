//
//  TestService.swift
//  
//
//  Created by Dmitry Demyanov on 13.11.2020.
//

import SurfGenKit

enum TestService: String, CaseIterable {
    case pet = "Pet"
    
    private enum Constants {
        static let basePath = "TestFiles/"
    }

    func fileName(for servicePart: ServicePart) -> String {
        return servicePart.buildName(for: rawValue, platform: .swift) + ".swift"
    }

    func getCode(for servicePart: ServicePart) -> String {
        return FileReader().readFile("\(filePath(for: servicePart)).txt")
    }

    private func filePath(for servicePart: ServicePart) -> String {
        return Constants.basePath + servicePart.buildName(for: rawValue, platform: .swift)
    }

}
