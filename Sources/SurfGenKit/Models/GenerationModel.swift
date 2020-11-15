//
//  GenerationModel.swift
//  SurfGenKit
//
//  Created by Mikhail Monakov on 23/03/2020.
//

public typealias ModelGeneratedModel = [ModelType: [FileModel]]

public typealias ServiceGeneratedModel = [ServicePart: FileModel]

public struct FileModel: Hashable {
    public let fileName: String
    public let code: String
}
