//
//  File.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation
import Common

public enum PathNormalizer {

    /// For details look in `PathNormalizerTests`
    public static func normalize(path: String) throws -> String {
        let url = URL(string: path)

        var components = url!.pathComponents

        var normalized = [String]()

        var componentsToRemove = 0

        if components.first == "/" {
            components = .init(components.dropFirst())
        }

        for cmp in components.reversed() {
            if cmp == "../" || cmp == ".." {
                componentsToRemove += 1
            } else {
                if cmp == "." { continue }

                if componentsToRemove != 0 {
                    componentsToRemove -= 1
                    continue
                }
                normalized.append(cmp)
            }
        }

        if componentsToRemove != 0 {
            throw CustomError(message: "Error occured while normalizing path \(path)\nThere are more `back steps`(../ <-- this symbol) then path components before it.\nFor example if you have `a/b/../../../` then we don't know what is the path.\nIn common we can assume it as `../` but we considered to don't do it.\nIt might happen because you specify relative path to root specification. Just specify absolute path and it will be fixed.\nIf not - contact us plz")
        }

        var result = normalized.reversed().joined(separator: "/")

        if path.first == "/" {
            result.insert("/", at: result.startIndex)
        }

        return result
    }
}

extension String {
    public func normalized() throws -> String {
        return try PathNormalizer.normalize(path: self)
    }
}
