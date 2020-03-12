//
//  PropertiesFinderTests.swift
//  YamlParserTests
//
//  Created by Mikhail Monakov on 13/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import XCTest
@testable import YamlParser
import Swagger

extension RendezvousModel {

    var allProperties: Set<String> {
        switch self {
        case .products:
            return ["products", "metadata"]
        case .geoPos:
            return ["lat", "long"]
        case .searchHint:
            return ["value", "expand_data"]
        case .productDetail:
            return ["id", "title", "discount_price", "retail_price", "preview_picture",
                    "article", "category_name", "brand_id", "brand_name", "brand_name", "rating",
                    "review_count", "fav_count", "is_on_sale", "is_new", "is_bought_by_me",
                    "is_sized", "color", "fur_status", "sizes", "promo_pictures",
                    "available_sizes", "cart_size", "favorite_size", "color_variations",
                    "pictures", "video", "video_360", "video_review", "url"]
        case .profile:
            return ["birthday", "gender", "id", "foot_size",
                    "first_name", "last_name", "middle_name",
                    "phone", "card", "email"]
        }
    }

}

class PropertiesFinderTests: XCTestCase {

    func testRendezvousPropertiesSearch() {
        do {
            let spec = try SwaggerSpec(string: FileReader().readFile("rendezvous", "yaml"))
            RendezvousModel.allCases.forEach { checkPropertiesFinder(for: $0, with: spec.components.schemas) }
        } catch {
            XCTFail("Error loading test spec")
        }
    }

    func checkPropertiesFinder(for model: RendezvousModel, with schemas: [ComponentObject<Schema>]){
        guard let schema = schemas.first(where: { $0.name == model.rawValue }) else {
            XCTFail("No such model in schemas")
            return
        }

        let result = PropertiesFinder().findProperties(for: schema.value)
        let resultedProperties = Set((result.0 + result.1).map { $0.name })
        XCTAssertEqual(model.allProperties, resultedProperties)

//        let newComponent = GroupResolver().resolve(for: [schema])
//        print(newComponent)
    }

}


