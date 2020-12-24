//
//  EnumGenerationModel.swift
//  SurfGenKit
//
//  Created by Mikhail Monakov on 18/03/2020.
//

public struct EnumCase: Equatable {
    let name: String?
    let camelCaseName: String?
    let value: String
}

public struct EnumGenerationModel: Equatable {
    let enumName: String
    let enumType: String
    let cases: [EnumCase]
    let description: String
}
