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
            return model.form(name: "TestFiles/ProfileCustomData")
        case .shop:
            return model.form(name: "TestFiles/Shop")
        case .shopLocation:
            return model.form(name: "TestFiles/ShopLocation")
        case .token:
            return model.form(name: "TestFiles/ContactToken")
        }
    }

    func getTestFileName(for model: ModelType) -> String {
        switch self {
        case .profile:
            return model.form(name: "ProfileCustomData")
        case .shop:
            return model.form(name: "Shop")
        case .shopLocation:
            return model.form(name: "ShopLocation")
        case .token:
            return model.form(name: "ContactToken")
        }
    }

}
