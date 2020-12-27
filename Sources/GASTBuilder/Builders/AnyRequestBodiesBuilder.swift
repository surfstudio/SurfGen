//
//  File.swift
//  
//
//  Created by Александр Кравченков on 27.12.2020.
//

import Foundation
import GASTTree
import Swagger
import Common

public protocol RequestBodiesBuilder {
    func build(requestBodies: [ComponentObject<RequestBody>]) throws -> [ComponentRequestBodyNode]
}

public struct AnyRequestBodiesBuilder: RequestBodiesBuilder {

    public init() { }

    public func build(requestBodies: [ComponentObject<RequestBody>]) throws -> [ComponentRequestBodyNode] {
        throw CustomError.notInplemented()
    }
}
