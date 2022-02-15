//
//  SourceCode.swift
//  
//
//  Created by Dmitry Demyanov on 13.01.2021.
//

/// This model keeps generated code, name and location of file to create with this code
public struct SourceCode {

    public init(
        code: String,
        fileName: String,
        destinationPath: String,
        apiDefinitionFileRef: String
    ) {
        self.code = code
        self.fileName = fileName
        self.destinationPath = destinationPath
        self.apiDefinitionFileRef = apiDefinitionFileRef
    }

    public let code: String
    public let fileName: String
    public let destinationPath: String
    public let apiDefinitionFileRef: String
}
