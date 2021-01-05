//
//  File.swift
//  
//
//  Created by Александр Кравченков on 28.12.2020.
//

import Foundation
import Common

public class FileProviderStub: FileProvider {

    public var isReadableFile: Bool = false

    public var files: [String: Data] = [:]

    public var readCount = 0

    public init() { }

    public func isReadableFile(at path: String) -> Bool {
        return isReadableFile
    }

    public func readFile(at path: String) throws -> Data? {
        readCount += 1
        return files[path]
    }
}
