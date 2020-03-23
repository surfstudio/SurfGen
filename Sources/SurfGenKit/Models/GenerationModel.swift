//
//  GenerationModel.swift
//  SurfGenKit
//
//  Created by Mikhail Monakov on 23/03/2020.
//

public typealias GenerationModel = [ModelType: [FileModel]]

public struct FileModel: Hashable {
    public let fileName: String
    public let code: String
}
