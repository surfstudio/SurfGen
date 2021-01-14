//
//  ReferenceExecutor.swift
//
//
//  Created by Александр Кравченков on 12.12.2020.
//

import Foundation
import Yams
import Common

/// This class extracts all references (`$ref` tag) from specific OpenAPI specification file recursively
///
/// For example:
/// We have file at path`../api/billings/api.yaml`
/// Inside this file we have some REST methods which contain references on some models in another spec files.
///
/// `ReferenceExtractor` will extract referenced files' pathes
/// And also it will read each file and will make the same extraction
/// And it will repeat it until it read all dependencies
///
/// `ReferenceExtractor` is proof to reference cycles
///
/// **ATTENTION**
/// Doesn't exclude local references. SO if ypu have reference which is local (wihtout file path before `#`)
/// Extractor doesn't return it in result array.
///
/// **WARNING**
/// Isn't thread-safe!
/// If you want to working in parallel, you should create different instances of this class
///
/// **NOTICE**
/// May be tricky with refs which were inserted in an array
public class ReferenceExtractor {
    let rootSpecPath: URL
    let fileProvider: FileProvider

    // this field will be fulfilled by extract process
    var readStack: [String]

    var dependencies: [Dependency]

    /// Initializer
    ///
    /// - Parameters:
    ///     - pathToSpec: Path to YAML specification from which yupu need to extract references
    ///     - fileProvider: Will be used for reading strings in utf8 encoding
    /// - Throws:
    ///    - CustomError: In case when file at `pathToSpec` isn't readable
    public init(pathToSpec: URL, fileProvider: FileProvider) throws {

        let normalizedPath = try pathToSpec.absoluteString.normalized()

        guard let url = URL(string: normalizedPath) else {
            throw CommonError(message: "We couldn't create an URI after make rootPath \(pathToSpec) normalized: \(normalizedPath)")
        }

        self.rootSpecPath = url

        self.fileProvider = fileProvider

        self.dependencies = []

        guard fileProvider.isReadableFile(at: pathToSpec.absoluteString) else {
            throw CommonError(message: "file at path \(pathToSpec) isn't readable")
        }
        self.readStack = [pathToSpec.absoluteString]
    }
}

extension ReferenceExtractor {

    /// **WARNING**
    /// Doesn't return link on `rootSpecPath`
    /// If you need it you shoul do it by yourself
    public func extract() throws -> (uniqRefs: [String], dependecies: [Dependency]) {
        let spec = try wrap(
            self.loadSpec(path: self.rootSpecPath.absoluteString),
            message: "While loading spec at \(self.rootSpecPath.absoluteString)")

        var root = Dependency(pathToCurrentFile: self.rootSpecPath.absoluteString, dependecies: [:])

        try collectAllRefs(in: spec, file: self.rootSpecPath.absoluteString, currentDependency: &root)

        self.dependencies.append(root)

        var copy = self.readStack
        copy.removeAll(where: { $0 == self.rootSpecPath.absoluteString })

        return (copy, self.dependencies)
    }

    func loadSpec(path: String) throws -> [String: Any] {

        let str = try self.fileProvider.readTextFile(at: path)

        guard
            let parsed = try Yams.load(yaml: str),
            let spec = parsed as? [String: Any]
        else {
            throw CommonError(message: "Something went wrong with file at path \(path). Wa had parsed it, but we couldn't transform YAML to dictionary")
        }

        return spec
    }

    func collectAllRefs(in spec: [String: Any], file: String, currentDependency: inout Dependency) throws {

        for (key, value) in spec {
            switch value {
            case let arr as [[String: Any]]:
                try arr.forEach { try collectAllRefs(in: $0, file: file, currentDependency: &currentDependency) }
            case let sp as [String: Any]:
                try self.collectAllRefs(in: sp, file: file, currentDependency: &currentDependency)
            case let str as String:

                guard key == "$ref" else {
                    continue
                }
                let splited = str.splitOnFilePathAndYamlPath()
                // if file path is empty then we must skip it because it is reference to local (for current file) entity
                // or it's just a broken ref
                guard !splited.filePath.isEmpty else {
                    continue
                }

                try readOther(filePath: splited.filePath, fromFile: file, currentDependency: &currentDependency, refString: str)
            default:
                continue
            }
        }
    }


    func readOther(filePath: String, fromFile: String, currentDependency: inout Dependency, refString: String) throws {
        guard var rootUrl = URL(string: currentDependency.pathToCurrentFile) else {
            throw CommonError(message: "Couldn't convert \(currentDependency.pathToCurrentFile) to URI")
        }

        rootUrl.deleteLastPathComponent()

        let resultedUrlToFileToParse = try rootUrl.absoluteString.appending(filePath).normalized()

        currentDependency.dependecies[refString] = resultedUrlToFileToParse

        // if we already read this file we won't read it again
        if self.readStack.contains(resultedUrlToFileToParse) {
            return
        }

        // mark it as readed and continue parsing
        // it's a protection against "genius" who make reference to `file A` from `file A`
        //
        // for example in file `models.yaml` sometimes you can see: `$ref:"models.yaml#/..."`
        // and it's a protection just from this
        //
        // the idea is:
        // if we have read this file
        // then we shouldn't read it again because we would execute all refs eventually
        // and we don't need to read in twice
        self.readStack.append(resultedUrlToFileToParse)

        let res = try wrap(
            self.loadSpec(path: resultedUrlToFileToParse),
            message: "While loading spec at \(resultedUrlToFileToParse)"
        )

        var newDependency = Dependency(pathToCurrentFile: resultedUrlToFileToParse, dependecies: [:])

        try collectAllRefs(in: res, file: filePath, currentDependency: &newDependency)

        self.dependencies.append(newDependency)
    }
}

extension String {
    /// Splits ../common/errors.yaml#/components/schemas/ApiErrorResponse on
    /// ../common/errors.yaml
    /// and
    /// /components/schemas/ApiErrorResponse
    func splitOnFilePathAndYamlPath() -> (filePath: String, yamlPath: String) {
        let spl = self.split(separator: "#")

        guard spl.count == 2 else {
            return ("", "")
        }

        return (String(spl[0]), String(spl[1]))
    }
}
