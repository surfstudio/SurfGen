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
///
/// **WARNING**
///
/// Excluding doesn't work for single file
public struct OpenAPILinter: PipelineStage {

    /// **WARNING**
    /// Url should be absolute
    /// Code called this struct should take care about it.
    ///
    /// `OpenAPILinter` will manually convert string to URL in `init`
    public let filesToIgnore: Set<URL>
    public let next: AnyPipelineStage<[URL]>
    public let log: Logger

    public init(filesToIgnore: Set<String>,
                next: AnyPipelineStage<[URL]>,
                log: Logger) {
        self.filesToIgnore = Set(filesToIgnore.map { URL(fileURLWithPath: $0) })
        self.next = next
        self.log = log
    }

    /// Check iput is file or dir and run linitng
    ///
    /// For single file run single linting
    ///
    /// For dir previously read all files recursively and then run lint for each read file
    ///
    /// **WARNING**
    /// `input` should be string without `file://` schema
    public func run(with input: String) throws {
        guard let rootUrl = URL(string: input) else {
            throw CommonError(message: "Can convert input: \(input) to URL path")
        }

        // because resourceValues require `file://` schema
        // but for the next usage in may be dagerous to pass url like that
        let schemaRootUrl = URL(fileURLWithPath: input)

        // TEST_IT: On Different OS

        let isDir = try wrap(
            schemaRootUrl.resourceValues(forKeys: [.isDirectoryKey]).isDirectory,
            message: "While read metadata for item at path \(rootUrl.absoluteString)"
        )

        guard let isDirGuarded = isDir else {
            throw CommonError(message: "Can't read metadata for \(rootUrl.absoluteString)")
        }

        if isDirGuarded {
            log.debug("\(rootUrl.absoluteString) was determined as directory")
            try self.runForDir(at: rootUrl)
        } else {
            log.debug("\(rootUrl.absoluteString) was determined as single file")
            try self.runForSingleFile(at: rootUrl)
        }

    }

    private func runForSingleFile(at path: URL) throws {
        try next.run(with: [path])
    }

    private func runForDir(at path: URL) throws {
        let files = try wrap(
            self.readFilesRecursively(at: path),
            message: "While recursively read files at path \(path.absoluteString)"
        )

        try self.next.run(with: files)
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

                guard fileAttributes.isRegularFile == true else {
                    log.debug("\(fileURL.absoluteString) is not a regular file")
                    continue
                }

                guard fileURL.pathExtension == "yaml" else {
                    log.debug("\(fileURL.absoluteString) isn't yaml file. Skip it")
                    continue
                }

                guard !self.filesToIgnore.contains(fileURL) else {
                    log.debug("\(fileURL.absoluteString) is excluded. Skip it")
                    continue
                }

                files.append(fileURL)
            } catch {
                log.error("Can't read attributes for file \(fileURL.absoluteString). It will be skiped!")
            }
        }

        return try files.map { fileUrl in
            let string = fileUrl.absoluteString.replacingOccurrences(of: "file://", with: "")

            guard let url = URL(string: string) else {
                throw CommonError(message: "Can't convert \(string) to url")
            }

            return url
        }

    }
}
