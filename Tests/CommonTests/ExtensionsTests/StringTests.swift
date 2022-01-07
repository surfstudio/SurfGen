//
//  StringTests.swift
//  
//
//  Created by Александр Кравченков on 20.10.2021.
//

import Foundation
import XCTest
import Common

public final class StringTests: XCTestCase {

    func testUpperCaseToCamelCase() {
        // Arrange

        let dataWithExpectedResults = [
            "FIRST": "first",
            "FIRST_SECOND": "firstSecond",
            "First_sEcONd": "firstSecond",
            "first_second": "firstSecond",
            "first-second": "first-second",
            "FirstSecond": "firstsecond",
        ]

        // Act - Assert

        for (key, value) in dataWithExpectedResults {
            XCTAssertEqual(key.upperCaseToCamelCase(), value)
        }
    }

    func testUpperCaseToCamelCaseOrSelf() {
        // Arrange

        let dataWithExpectedResults = [
            "FIRST": "first",
            "FIRST_SECOND": "firstSecond",
            "First_sEcONd": "First_sEcONd",
            "first_second": "first_second",
            "first-second": "first-second",
            "FirstSecond": "FirstSecond",
        ]

        // Act - Assert

        for (key, value) in dataWithExpectedResults {
            XCTAssertEqual(key.upperCaseToCamelCaseOrSelf(), value)
        }
    }
}