//
//  GenerationModel.swift
//  SurfGenKit
//
//  Created by Mikhail Monakov on 23/03/2020.
//

public typealias ModelGenerationModel = [ModelType: [FileModel]]

public typealias ServiceGenerationModel = [ServicePart: FileModel]

public struct FileModel: Hashable {
    public let fileName: String
    public let code: String
}
