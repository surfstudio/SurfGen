//
//  PrefixCutterTests.swift
//  
//
//  Created by Александр Кравченков on 20.08.2021.
//

import Foundation
import XCTest
@testable import Operations


// Cases:
//
// 1. Check that cutting work
// 2. Check that cutter with 2 strings will apply only 1 cut operation
// 3. Check that cutter wont apply operation if strings don't match
// 4. Check that cutter wont apply operation if mask is not in prefix but in secod part of url

public class PrefixCutterTests: XCTestCase {

    func testCuttingWorks() {
        // Arrange

        let cuttingMask = "/api"
        let url = "/api/test"
        let expectedUrl = "/test"

        let cutter = PrefixCutter(prefixesToCut: [cuttingMask])

        // Act

        let newUrl = cutter.Run(urlToCut: url)

        // Assert

        XCTAssertEqual(newUrl, expectedUrl)
    }

    func testCutterWithTwoStringsWillApplyOnlyOneOperation() {
        // Arrange

        let cuttingMasks = Set(["/api", "/test"])
        let url = "/api/test"
        let expectedUrl = "/test"

        let cutter = PrefixCutter(prefixesToCut: cuttingMasks)

        // Act

        let newUrl = cutter.Run(urlToCut: url)

        // Assert

        XCTAssertEqual(newUrl, expectedUrl)
    }

    func testCutterWontApplyOperationIfStringsDoNotMacth() {
        // Arrange

        let cuttingMasks = Set(["/someurl"])
        let url = "/api/test"

        let cutter = PrefixCutter(prefixesToCut: cuttingMasks)

        // Act

        let newUrl = cutter.Run(urlToCut: url)

        // Assert

        XCTAssertNil(newUrl)
    }

    // 4. Check that cutter wont apply operation if mask is not in prefix but in secod part of url

    func testCutterWontApplyOperationIfMaskIsNotInPrefixButInSecondPart() {
        // Arrange

        let cuttingMasks = Set(["/test"])
        let url = "/api/test"

        let cutter = PrefixCutter(prefixesToCut: cuttingMasks)

        // Act

        let newUrl = cutter.Run(urlToCut: url)

        // Assert

        XCTAssertNil(newUrl)
    }
}
