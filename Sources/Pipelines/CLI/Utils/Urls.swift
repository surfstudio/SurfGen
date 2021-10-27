//
//  File.swift
//  
//
//  Created by Александр Кравченков on 26.10.2021.
//

import Foundation
import Common

public enum Utils {
    
    public enum Urls {

        /// Gets relative url like `common/auth/api.yaml`
        /// Reads current execution directory
        /// And then concates them
        ///
        /// After that normalize result (to solve case when `url = "../../common..."`
        public static func makeUrlAbsolute(url: String) throws -> String {
            let path = FileManager.default.currentDirectoryPath
            return try (path + url).normalized()
        }

        /// Calls `makeUrlAbsolute`
        public static func makeUrlsAbsolute(urls: [String]) throws -> Set<String> {
            return .init(try urls.map { try makeUrlAbsolute(url: $0) })
        }

        /// Awaits string in format `path/to/yaml/file#/components/schemas/smt`
        /// Consider that `path/to/yaml/file` is relative path (relative to current execution place)
        public static func makeAstNodeRefAbsolute(ref: String) throws -> String {
            var splited = ref.split(separator: "#").map { String($0) }

            guard splited.count == 2 else {
                throw CommonError(message: "Path to AST node must have 2 part devided by #. But we got this -> \(ref)")
            }

            splited[0] = try wrap(makeUrlAbsolute(url: splited[0]), message: "While processing pathes to AST Nodes. Error occured on \(ref)")

            return splited.joined(separator: "#")
        }

        /// Calls `makeAstNodeRefAbsolute`
        public static func makeAstNodeRefsAbsolute(refs: [String]) throws -> Set<String> {
            return .init(try refs.map { try makeAstNodeRefAbsolute(ref: $0) })
        }

        public static func addForwardingSlashIfNeeded(urls: [String]) -> [String] {
            return urls.map { val in
                return val.hasPrefix("/") ? val : "/"+val
            }
        }

        public static func validateAstNodePath(string: String) -> Bool {
            return string.split(separator: "#").count == 2
        }

        public static func validateAstNodePathesAndExistIfError(pathes: [String], loger: Loger) {
            var isErr = false

            pathes.forEach { val in
                if !validateAstNodePath(string: val) {
                    loger.fatal("AST Node Path \(val) is invalid")
                    isErr = true
                }
            }

            if isErr {
                exit(-1)
            }
        }
    }
}
