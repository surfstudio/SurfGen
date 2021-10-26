//
//  ASTNodeExcluder.swift
//  
//
//  Created by Александр Кравченков on 25.10.2021.
//

import Foundation
import Common
import Swagger

public struct ASTNodeExcluder {

    typealias ExcludePathAndRef = (path: String, ref: String)

    public let logger: Loger?

    public init(logger: Loger?) {
        self.logger = logger
    }

    /// Run excluding logic. In the result will be new tree
    ///
    /// The idea:
    /// 1. Find all nodes which were mentioned in `excludeList`
    /// 2. Remove them from tree
    /// 3. Find all references on models from `excludeList` (in object's properties, operations, etc.)
    /// 4. Replace that references by constant `Constants.ASTNodeReference.todo`
    ///
    /// **WARNING**
    ///
    /// This method works with pathes from excludeList as is
    /// It's up to you to make them absolute like pathes from `Dependency`
    ///
    /// - Parameters
    ///     - tree: AST Tree to process in exclude nodes
    ///     - excludeList: `path/to/file#/components/schemas/Model`
    public func exclude(from tree: OpenAPIASTTree, excludeList: Set<String>) throws -> OpenAPIASTTree {

        // 1. Find all nodes to exclude
        // 2. Find all usages of that nodes
        // 3. Remove (1) from tree
        // 4. Create reference to a stub object on the place where (1) were used

        // In time of generation we can delete this stub from tree

        var mutCopy = tree

        let references = try wrap(
            self.unwrapExcludeReferences(from: excludeList),
            message: "While validation excluding list"
        )

        // references which point to this tree
        let valubaleReferences = references.filter { ref in
            return ref.path == tree.rawDependency.pathToCurrentFile
        }

        if !valubaleReferences.isEmpty {

            self.logger?.debug("Tree at path \(tree.rawDependency.pathToCurrentFile) contain references \(valubaleReferences) from excluding list")

            /// We removed all nodes by references
            try valubaleReferences.forEach { ref in
                mutCopy = try self.runExclusion(tree: mutCopy, ref: ref.ref)
            }
        }

        try references.forEach { ref in
            mutCopy = try self.replaceReference(in: mutCopy, ref: ref.ref, path: ref.path)
        }

        /// Now we have to find all references on this models and replace them

        return mutCopy
    }

    func runExclusion(tree: OpenAPIASTTree, ref: String) throws -> OpenAPIASTTree {

        let paths = ref.split(separator: "/").map { String($0) }

        guard paths.count > 1 else {
            throw CommonError(message: "Ref \(ref) has a wrong format")
        }

        switch paths[0] {
        case "components":
            guard paths.count > 2 else {
                throw CommonError(message: "Ref \(ref) is invalid. Shuld have > 2 ref's components")
            }

            return try self.removeComponent(tree: tree, wholeRef: ref, currentComponent: paths[1], components: paths)
        case "paths":
            var otherPath = paths.dropFirst().joined(separator: "/")
            otherPath = otherPath.hasPrefix("/") ? otherPath : "/" + otherPath
            return try self.removePath(tree: tree, pathString: otherPath)
        default:
            throw CommonError(message: "Component \(paths[0]) in ref \(ref) is unsupported or unknown")
        }
    }
}

// MARK: - Remove Components

private extension ASTNodeExcluder {
    func removeComponent(tree: OpenAPIASTTree,
                         wholeRef: String,
                         currentComponent: String,
                         components: [String]) throws -> OpenAPIASTTree {

        var mutableTree = tree
        var mutableComponents = mutableTree.currentTree.components

        switch currentComponent {
        case "schemas":

            guard let index = tree.currentTree.components.schemas.firstIndex(where: { $0.name == components[2] }) else {
                throw CommonError(message: "Schema with name \(components[2]) wasn't found in tree from file \(tree.rawDependency.pathToCurrentFile)")
            }

            var schemas = mutableTree.currentTree.components.schemas

            schemas.remove(at: index)

            mutableComponents.schemas = schemas
            mutableTree.currentTree.components = mutableComponents

            self.logger?.info("Remove \(currentComponent) \(tree.currentTree.components.schemas[index].name) from \(tree.rawDependency.pathToCurrentFile)")

            return mutableTree
        case "parameters":
            guard let index = tree.currentTree.components.parameters.firstIndex(where: { $0.name == components[2] }) else {
                throw CommonError(message: "Parameter with name \(components[2]) wasn't found in tree from file \(tree.rawDependency.pathToCurrentFile)")
            }

            var parameters = mutableTree.currentTree.components.parameters

            parameters.remove(at: index)

            mutableComponents.parameters = parameters
            mutableTree.currentTree.components = mutableComponents

            self.logger?.info("Remove \(currentComponent) \(tree.currentTree.components.parameters[index].name) from \(tree.rawDependency.pathToCurrentFile)")

            return mutableTree
        case "requestBodies":
            guard let index = tree.currentTree.components.requestBodies.firstIndex(where: { $0.name == components[2] }) else {
                throw CommonError(message: "RequestBody with name \(components[2]) wasn't found in tree from file \(tree.rawDependency.pathToCurrentFile)")
            }

            var requestBodies = mutableTree.currentTree.components.requestBodies

            requestBodies.remove(at: index)

            mutableComponents.requestBodies = requestBodies
            mutableTree.currentTree.components = mutableComponents

            self.logger?.info("Remove \(currentComponent) \(tree.currentTree.components.requestBodies[index].name) from \(tree.rawDependency.pathToCurrentFile)")

            return mutableTree
        case "headers":
            guard let index = tree.currentTree.components.headers.firstIndex(where: { $0.name == components[2] }) else {
                throw CommonError(message: "Header with name \(components[2]) wasn't found in tree from file \(tree.rawDependency.pathToCurrentFile)")
            }

            var headers = mutableTree.currentTree.components.headers

            headers.remove(at: index)

            mutableComponents.headers = headers
            mutableTree.currentTree.components = mutableComponents

            self.logger?.info("Remove \(currentComponent) \(tree.currentTree.components.headers[index].name) from \(tree.rawDependency.pathToCurrentFile)")

            return mutableTree
        case "responses":
            guard let index = tree.currentTree.components.responses.firstIndex(where: { $0.name == components[2] }) else {
                throw CommonError(message: "Response with name \(components[2]) wasn't found in tree from file \(tree.rawDependency.pathToCurrentFile)")
            }

            var responses = mutableTree.currentTree.components.responses

            responses.remove(at: index)

            mutableComponents.responses = responses
            mutableTree.currentTree.components = mutableComponents

            self.logger?.info("Remove \(currentComponent) \(tree.currentTree.components.responses[index].name) from \(tree.rawDependency.pathToCurrentFile)")

            return mutableTree
        default:
            throw CommonError(message: "Component \(currentComponent) in ref \(wholeRef) is unsupported or unknown")
        }
    }
}


// MARK: - Remove Pathes

private extension ASTNodeExcluder {
    func removePath(tree: OpenAPIASTTree, pathString: String) throws -> OpenAPIASTTree {

        var mutTree = tree

        let splited = pathString.split(separator: "~")

        guard let pathIndex = mutTree.currentTree.paths.firstIndex(where: { $0.path == splited[0] }) else {
            throw CommonError(message: "Path with URI \(splited[0]) wasn't found in tree from file \(tree.rawDependency.pathToCurrentFile)")
        }

        guard
            splited.count == 2
        else {
            self.logger?.info("Removed whole path \(splited[0]) from \(tree.rawDependency.pathToCurrentFile)")
            mutTree.currentTree.paths.remove(at: pathIndex)
            return mutTree
        }

        guard let operationIndex = mutTree.currentTree.paths[pathIndex].operations.firstIndex(where: { $0.method.rawValue == splited[1] }) else {
            throw CommonError(message: "Operation with method \(splited[1]) at path with \(splited[0]) wasn't found in tree from file \(tree.rawDependency.pathToCurrentFile)")
        }

        mutTree.currentTree.paths[pathIndex].operations.remove(at: operationIndex)

        self.logger?.info("Removed method \(splited[1]) from path \(splited[0]) from file \(tree.rawDependency.pathToCurrentFile)")

        return mutTree
    }
}

// MARK: - Replace References

private extension ASTNodeExcluder {
    /// Traverse the whole `tree` and replace all references `path#ref` on `Constants.ASTNodeReference.todo`
    /// - Parameters:
    ///     - tree: Tree for recursive traversing
    ///     - ref: Right part of the OpenAPI reference. A reference from excluding list
    ///     - path: Ligt paty o
    func replaceReference(in tree: OpenAPIASTTree, ref: String, path: String) throws -> OpenAPIASTTree {
        var mutableCmponents = tree.currentTree.components

        for i in 0..<mutableCmponents.schemas.count {

            var schema = mutableCmponents.schemas[i]

            schema.value = try wrap(self.processSchema(
                schema: schema.value,
                tree: tree,
                ref: ref,
                path: path
            ), message: "While traversing schema \(schema.name)")

            mutableCmponents.schemas[i] = schema
        }

        var mutableTree = tree

        mutableTree.currentTree.components = mutableCmponents

        return fixDependencies(in: mutableTree, ref: ref, path: path)
    }

    func processSchema(schema: Schema, tree: OpenAPIASTTree, ref: String, path: String) throws -> Schema {

        switch schema.type {
        case .reference(let val):

            guard try self.isNeedToReplaceReference(
                refToReplace: val.rawValue,
                tree: tree,
                ref: ref,
                path: path
            ) else {
                return schema
            }

            return .init(metadata: schema.metadata, type: .reference(.init(Constants.ASTNodeReference.todo)))
        case .object(var obj):
            for i in 0 ..< obj.properties.count {
                let propSchema = try self.processSchema(
                    schema: obj.properties[i].schema,
                    tree: tree,
                    ref: ref,
                    path: path
                )
                var prop = obj.properties[i]

                prop.schema = propSchema
                obj.properties[i] = prop
            }

            return .init(metadata: schema.metadata, type: .object(obj))
        case .array(var arr):
            switch arr.items {
            case .multiple(let val):
                let res = try val.map { elem in
                    return try self.processSchema(
                        schema: elem,
                        tree: tree,
                        ref: ref,
                        path: path
                    )
                }

                arr.items = .multiple(res)
                return .init(metadata: schema.metadata, type: .array(arr))
            case .single(let val):
                let res = try self.processSchema(
                    schema: val,
                    tree: tree,
                    ref: ref,
                    path: path
                )
                arr.items = .single(res)
                return .init(metadata: schema.metadata, type: .array(arr))
            }
        case .group(var group):
            let res = try group.schemas.map { elem in
                return try self.processSchema(
                    schema: elem,
                    tree: tree,
                    ref: ref,
                    path: path
                )
            }

            group.schemas = res
            return .init(metadata: schema.metadata, type: .group(group))
        case .any, .integer, .number, .string, .boolean:
            return schema
        }
    }
}

// MARK: - Helpers

private extension ASTNodeExcluder {
    func isNeedToReplaceReference(refToReplace: String, tree: OpenAPIASTTree, ref: String, path: String) throws  -> Bool {
        let splited = refToReplace.split(separator: "#").map { String($0) }

        if splited.count == 2 {
            // if name name part (after #) doesn't equal to ref then skip processing
            guard ref == splited[1] else {
                return false
            }

            // NOTE - It's not a hack. But still seems not so pretty :) There are another way to do it withput dependecies aaray
            // you need to tree.rawDependency.pathToCurrentFile.dropLatComponent (remove file) + splited[0] and normalize it

            return tree.rawDependency.dependecies[refToReplace] == path
        }

        // if name name part (after #) doesn't equal to ref then skip processing
        guard ref == splited[0] else {
            return false
        }

        // if this reference is local then check if path points to this tree

        return tree.rawDependency.pathToCurrentFile == path
    }

    func findTree(by path: String, in forest: [OpenAPIASTTree]) -> OpenAPIASTTree? {
        return forest.first { tree in
            return tree.rawDependency.pathToCurrentFile == path
        }
    }

    func unwrapExcludeReferences(from refs: Set<String>) throws -> [ExcludePathAndRef] {
        return try refs.map { val in
            let splited = val.split(separator: "#").map { String($0) }

            if splited.count != 2 {
                throw CommonError(message: "Exclude reference \(val) couldn't be splitted by `#` path and ref parts")
            }

            guard let url = URL(string: splited[0]) else {
                throw CommonError(message: "Couldn't create URI from path \(splited[0]) in reference \(val)")
            }

            return (url.absoluteString, splited[1])
        }
    }

    func fixDependencies(in tree: OpenAPIASTTree, ref: String, path: String) -> OpenAPIASTTree {
        guard
            let dependencyPath = tree.rawDependency.dependecies[ref],
            dependencyPath == path
        else {
            return tree
        }

        var mutableTree = tree

        mutableTree.rawDependency.dependecies.removeValue(forKey: ref)
        return mutableTree
    }
}
