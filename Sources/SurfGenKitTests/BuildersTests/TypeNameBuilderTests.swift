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

    func testPlainType() {
        let resultString = TypeNameBuilder().buildString(for: .plain("Int"), isOptional: true, modelType: .entity)
        XCTAssert(resultString == "Int?")
    }
    
    func testObjectTypeForEntity() {
        let resultString = TypeNameBuilder().buildString(for: .object("Profile"), isOptional: true, modelType: .entity)
        XCTAssert(resultString == "ProfileEntity?")
    }

    func testObjectTypeForEntry() {
        let resultString = TypeNameBuilder().buildString(for: .object("Profile"), isOptional: false, modelType: .entry)
        XCTAssert(resultString == "ProfileEntry")
    }
    
    func testArrayOfPlainType() {
        let resultString = TypeNameBuilder().buildString(for: .array(.plain("String")), isOptional: true, modelType: .entity)
        XCTAssert(resultString == "[String]?")
    }
    
    func testArrayOfObjectsTypeForEntityType() {
        let resultString = TypeNameBuilder().buildString(for: .array(.object("MetaInfo")), isOptional: true, modelType: .entity)
        XCTAssert(resultString == "[MetaInfoEntity]?")
    }
    
    func testArrayOfObjectsTypeForEntryType() {
        let resultString = TypeNameBuilder().buildString(for: .array(.object("MetaInfo")), isOptional: true, modelType: .entry)
        XCTAssert(resultString == "[MetaInfoEntry]?")
    }

}
