//
//  TypeNameBuilderTests.swift
//  ModelsCodeGenerationTests
//
//  Created by Mikhail Monakov on 24/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import XCTest
@testable import SurfGenKit

class TypeNameBuilderTests: XCTestCase {

    private let typeNameBuilder = TypeNameBuilder(platform: .swift)

    func testPlainType() {
        let resultString = typeNameBuilder.buildString(for: .plain("Int"), modelType: .entity)
        XCTAssert(resultString == "Int")
    }
    
    func testObjectTypeForEntity() {
        let resultString = typeNameBuilder.buildString(for: .object("Profile"), modelType: .entity)
        XCTAssert(resultString == "ProfileEntity")
    }

    func testObjectTypeForEntry() {
        let resultString = typeNameBuilder.buildString(for: .object("Profile"), modelType: .entry)
        XCTAssert(resultString == "ProfileEntry")
    }
    
    func testArrayOfPlainType() {
        let resultString = typeNameBuilder.buildString(for: .array(.plain("String")), modelType: .entity)
        XCTAssert(resultString == "[String]")
    }
    
    func testArrayOfObjectsTypeForEntityType() {
        let resultString = typeNameBuilder.buildString(for: .array(.object("MetaInfo")), modelType: .entity)
        XCTAssert(resultString == "[MetaInfoEntity]")
    }
    
    func testArrayOfObjectsTypeForEntryType() {
        let resultString = typeNameBuilder.buildString(for: .array(.object("MetaInfo")), modelType: .entry)
        XCTAssert(resultString == "[MetaInfoEntry]")
    }

}
