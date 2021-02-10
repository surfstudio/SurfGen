//
//  TestModels.swift
//  ModelsCodeGenerationTests
//
//  Created by Mikhail Monakov on 02/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

@testable import SurfGenKit

enum TestModels: CaseIterable {
    case shopLocation
    case shop
    case profile
    case token

    var rootSubNodes: [ASTNode] {
        switch self {
        case .profile:
            return [NodesBuilder.formProfileCustomDataNode()]
        case .shop:
            return [NodesBuilder.formShopDeclNode()]
        case .shopLocation:
            return [NodesBuilder.formShopLocationDeclNode()]
        case .token:
            return [NodesBuilder.formTokenDeclNode()]
        }
    }

    func getFilePath(for model: ModelType) -> String {
        switch self {
        case .profile:
            return model.form(name: "TestFiles/ProfileCustomData", for: .swift)
        case .shop:
            return model.form(name: "TestFiles/Shop", for: .swift)
        case .shopLocation:
            return model.form(name: "TestFiles/ShopLocation", for: .swift)
        case .token:
            return model.form(name: "TestFiles/ContactToken", for: .swift)
        }
    }

    func getTestFileName(for model: ModelType) -> String {
        switch self {
        case .profile:
            return model.form(name: "ProfileCustomData", for: .swift)
        case .shop:
            return model.form(name: "Shop", for: .swift)
        case .shopLocation:
            return model.form(name: "ShopLocation", for: .swift)
        case .token:
            return model.form(name: "ContactToken", for: .swift)
        }
    }

}
