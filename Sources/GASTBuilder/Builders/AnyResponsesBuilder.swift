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

public protocol ResponsesBuilder {
    func build(respones: [ComponentObject<Response>]) throws -> [ComponentResponseNode]
}

public struct AnyResponsesBuilder: ResponsesBuilder {

    public init() { }

    public func build(respones: [ComponentObject<Response>]) throws -> [ComponentResponseNode] {
        throw CustomError.notInplemented()
    }
}
