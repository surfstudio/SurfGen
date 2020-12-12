//
//  FileProviderStub.swift
//  
//
//  Created by Александр Кравченков on 12.12.2020.
//

import Foundation
import ReferenceExtractor

class FileProviderStub: FileProvider {

    var isReadableFile: Bool = false

    var files: [String: Data] = [:]

    var readCount = 0

    func isReadableFile(at path: String) -> Bool {
        return isReadableFile
    }

    func readFile(at path: String) throws -> Data? {
        readCount += 1
        return files[path]
    }
}
