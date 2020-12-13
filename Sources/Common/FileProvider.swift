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


extension FileProvider {
    public func readTextFile(at path: String) throws -> String {
        guard let content = try self.readFile(at: path) else {
            throw CustomError(message: "file at path \(path) can't be readed. We read and got 0 bytes")
        }

        guard let str = String(data: content, encoding: .utf8) else {
            throw CustomError(message: "file at path \(path) perhaps isn't a text or it is in wrong encoding. We couldn't convert it in an utf8 string")
        }

        return str
    }
}
