//
//  FileProvider.swift
//
//
//  Created by Александр Кравченков on 12.12.2020.
//

import Foundation

/// Interface for object which can deal with files in file system
public protocol FileProvider {
    func isReadableFile(at path: String) -> Bool
    func readFile(at path: String) throws -> Data?
}

extension FileManager: FileProvider {
    public func readFile(at path: String) -> Data? {
        return self.contents(atPath: path)
    }

    public func isReadableFile(at path: String) -> Bool {
        return self.isReadableFile(atPath: path)
    }
}
