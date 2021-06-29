////
////  EnumGeneratorTests.swift
////  SurfGenKitTests
////
////  Created by Mikhail Monakov on 19/03/2020.
////
//
//import XCTest
//@testable import SurfGenKit
//import PathKit
//import Stencil
//
//class EnumGeneratorTests: XCTestCase {
//
//    func testEnumGeneration() {
//        TestEnumModels.allCases.forEach(checkGeneratedCode)
//    }
//
//    func checkGeneratedCode(for type: TestEnumModels) {
//        // given
//
//        let expectedCode = FileReader().readFile("\(type.filePath).txt")
//        let exptecedFileName =  "\(type.testFileName).swift"
//
//        // then
//
//        do {
//            let path = Path(#file) + "../../../../Templates/v2/Swift"
//
//            let loader = FileSystemLoader(paths: [path])
//            let environment = Environment(loader: loader)
//
//            let model = try EnumGenerator(platform: .swift).generateCode(for: type.typeDeclNode,
//                                                                         environment: environment)
//
//            XCTAssert(model.fileName == exptecedFileName, "File name is not equal to expected one (resulted value is \(model.fileName)")
//            XCTAssert(model.code == expectedCode, "Code is not equal to expected one (resulted value is \(model.code)")
//        } catch {
//            dump(error)
//            assertionFailure("Code generation thrown an exception")
//        }
//    }
//
//}
