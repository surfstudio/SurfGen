//
//  GeneratedCode.swift
//  
//
//  Created by Dmitry Demyanov on 13.01.2021.
//

/// This model keeps generated code, name and location of file to create with this code
public struct GeneratedCode {

    public init(code: String, fileName: String, destinationPath: String) {
        self.code = code
        self.fileName = fileName
        self.destinationPath = destinationPath
    }

    public let code: String
    public let fileName: String
    public let destinationPath: String
}
