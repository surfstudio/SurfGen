//
//  RendesvousModel.swift
//  YamlParserTests
//
//  Created by Mikhail Monakov on 06/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//


enum RendezvousModel: String, CaseIterable {
    case products = "ProductsResponse"
    case searchHint = "SearchHint"
    case geoPos = "GeoPosition"
    case productDetail = "ProductDetail"
    case profile = "Profile"

    var dependencies: Set<String> {
        switch self {
        case .products:
            return ["ProductsResponse", "ProductShort", "Metadata", "Id", "Color", "FurStatus", "Money"]
        case .searchHint:
            return ["ExpandProductsData", "SearchHint"]
        case .geoPos:
            return ["GeoPosition"]
        case .productDetail:
            return ["ProductDetail"]
        case .profile:
            return ["Profile", "ProfileCard", "Id", "Phone", "Money"]
        }
    }

}
