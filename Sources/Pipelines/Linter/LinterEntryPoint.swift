//
//  OpenAPILinter.swift
//  
//
//  Created by Александр Кравченков on 07.01.2021.
//

import Foundation
import Common

/// Contains pipeline for linting OpenAPI specification.
///
/// Can lint one file, or all files in directery and in all nested directories.
///
/// Provides possibility to ignore specific files.
///
/// **WARNING**
///
/// Excluding supports only pathes to files, not to dirs. We chose that way because we think, that it's very important to keep your specification clean.
/// And the harder it gets to skip the linter, the better it will.
public struct OpenAPILinter: PipelineEntryPoint {

    public let filesToIgnore: [String]
    public let next: AnyPipelineEntryPoint<URL>
    public let log: Logger

    public init(filesToIgnore: [String],
                next: AnyPipelineEntryPoint<URL>,
                log: Logger) {
        self.filesToIgnore = filesToIgnore
        self.next = next
        self.log = log
    }

    public func run(with input: String) throws {
        guard let rootUrl = URL(string: input) else {
            throw CommonError(message: "Can convert input: \(input) to URL path")
        }

        // TEST_IT: On Different OS

        let isDir = try wrap(
            rootUrl.resourceValues(forKeys: [.isDirectoryKey]).isDirectory,
            message: "While read metadata for item at path \(rootUrl.absoluteString)"
        )

        guard let isDirGuarded = isDir else {
            throw CommonError(message: "Can't read metadata for \(rootUrl.absoluteString)")
        }

        if isDirGuarded {
            
        } else {
            log.debug("\(rootUrl.absoluteString) was determined as single file")
            try self.runForSingleFile(at: rootUrl)
        }

    }

    private func runForSingleFile(at path: URL) throws {
        try next.run(with: path)
    }

    private func runForDir(at path: URL) throws {
        let files = try wrap(
            self.readFilesRecursively(at: path),
            message: "While recursively read files at path \(path.absoluteString)"
        )

        try files.forEach(self.runForSingleFile(at:))
    }

    private func readFilesRecursively(at path: URL) throws -> [URL] {
        var files = [URL]()

        let enumerator = FileManager.default.enumerator(
            at: path,
            includingPropertiesForKeys: [.isRegularFileKey],
            options: [.skipsHiddenFiles, .skipsPackageDescendants]
        )

        guard let iterator = enumerator else {
            throw CommonError(message: "Can't enumerate folder at path \(path.absoluteString)")
        }

        for case let fileURL as URL in iterator {
            do {
                let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
                if fileAttributes.isRegularFile! {
                    files.append(fileURL)
                }
            } catch {
                log.error("Can't read attributes for file \(fileURL.absoluteString). It will be skiped!")
            }
        }

        return files
    }
}
