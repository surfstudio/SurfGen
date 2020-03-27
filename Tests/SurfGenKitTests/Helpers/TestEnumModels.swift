//
//  TestEnumModels.swift
//  SurfGenKitTests
//
//  Created by Mikhail Monakov on 19/03/2020.
//

@testable import SurfGenKit

enum TestEnumModels: CaseIterable {
    case deliveryType
    case cancelOrder

    var typeDeclNode: ASTNode {
        switch self {
        case .deliveryType:
            return NodesBuilder.formDelivetyTypeDeclNode()
        case .cancelOrder:
            return NodesBuilder.formOrderCancelReasonDeclNode()
        }
    }

    var filePath: String {
        switch self {
        case .deliveryType:
            return "TestFiles/DeliveryType"
        case .cancelOrder:
            return "TestFiles/OrderCancelReason"
        }
    }

    var testFileName: String {
        switch self {
        case .deliveryType:
            return "DeliveryType"
        case .cancelOrder:
            return "OrderCancelReason"
        }
    }

}

