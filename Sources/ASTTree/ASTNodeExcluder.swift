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
        var mutableTree = tree

        mutableTree = try wrap(
            self.replaceReferenceInSchemas(tree: tree, ref: ref, path: path),
            message: "While replacing references in schemas"
        )

        mutableTree = try wrap(
            self.replaceReferencesInPathes(tree: mutableTree, ref: ref, path: path),
            message: "While replacing references in schemas"
        )

        return fixDependencies(in: mutableTree, ref: ref, path: path)
    }

    func replaceReferencesInPathes(tree: OpenAPIASTTree, ref: String, path: String) throws -> OpenAPIASTTree {

        var mutableCmponents = tree.currentTree.paths

        for i in 0..<mutableCmponents.count {

            var cmp = mutableCmponents[i]

            cmp.parameters = try wrap(
                self.replaceReferenceInParameters(params: cmp.parameters, tree: tree, ref: ref, path: path),
                message: "While replacing parameters in \(cmp.path)"
            )

            cmp.operations = try wrap(
                self.replaceReferenceInOperation(operations: cmp.operations, tree: tree, ref: ref, path: path),
                message: "While replacing operations in \(cmp.path)"
            )

            mutableCmponents[i] = cmp
        }

        var mutableTree = tree

        mutableTree.currentTree.paths = mutableCmponents

        return mutableTree
    }

    func replaceReferenceInOperation(
        operations: [Swagger.Operation],
        tree: OpenAPIASTTree,
        ref: String,
        path: String) throws -> [Swagger.Operation] {

            var mutableOperations = operations

            for j in 0..<mutableOperations.count {
                var mutableOperation = mutableOperations[j]

                let pathParams = try wrap(
                    self.replaceReferenceInParameters(params: mutableOperation.pathParameters, tree: tree, ref: ref, path: path),
                    message: "While replacing reference in parameter \(mutableOperation.method)"
                )

                let queryParams = try wrap(
                    self.replaceReferenceInParameters(params: mutableOperation.operationParameters, tree: tree, ref: ref, path: path),
                    message: "While replacing reference in parameter \(mutableOperation.method)"
                )

                mutableOperation.pathParameters = pathParams
                mutableOperation.operationParameters = queryParams

                mutableOperation.responses = try wrap(
                    self.replaceReferenceIn(responses: mutableOperation.responses, tree: tree, ref: ref, path: path),
                    message: "While replacing reference in responses in \(mutableOperation.method)"
                )

                if let defResp = mutableOperation.defaultResponse {
                    mutableOperation.defaultResponse = try wrap(
                        self.replaceReferenceIn(responses: [.init(statusCode: nil, response: defResp)], tree: tree, ref: ref, path: path).first?.response,
                        message: "While replacing reference in responses in \(mutableOperation.method)"
                    )
                }

                if let reqBody = mutableOperation.requestBody {
                    mutableOperation.requestBody = try wrap(
                        self.replaceReferenceIn(requestBody: reqBody, tree: tree, ref: ref, path: path),
                        message: "While replacing reference in requestBody in \(mutableOperation.method)"
                    )
                }

                mutableOperations[j] = mutableOperation
            }

            return mutableOperations
    }

    func replaceReferenceIn(
        requestBody: PossibleReference<RequestBody>,
        tree: OpenAPIASTTree,
        ref: String,
        path: String) throws -> PossibleReference<RequestBody> {

            switch requestBody {

            case .reference(let val):
                let flag = try self.isNeedToReplaceReference(refToReplace: val.rawValue, tree: tree, ref: ref, path: path)

                guard flag else {
                    return requestBody
                }

                return .reference(.init(Constants.ASTNodeReference.todo))
            case .value(var val):
                val.content = try self.replaceReferenceIn(content: val.content, tree: tree, ref: ref, path: path)
                return .value(val)
            }
    }

    func replaceReferenceIn(
        responses: [OperationResponse],
        tree: OpenAPIASTTree,
        ref: String,
        path: String) throws -> [OperationResponse] {
            var mutableResponses = responses

            for i in 0..<mutableResponses.count {

                var mutableResp = mutableResponses[i]

                switch mutableResp.response {
                case .reference(let val):
                    let flag = try wrap(
                        self.isNeedToReplaceReference(refToReplace: val.rawValue, tree: tree, ref: ref, path: path),
                            message: "While replacing reference in response with code \(mutableResp.statusCode ?? 0)"
                    )

                    guard flag else {
                        continue
                    }

                    mutableResp.response = .reference(.init(Constants.ASTNodeReference.todo))
                    mutableResponses[i] = mutableResp
                case .value(var val):
                    val.headers = try wrap(
                        self.raplceReferenceIn(headers: val.headers, tree: tree, ref: ref, path: path),
                        message: "While replacing reference in response with code \(mutableResp.statusCode ?? 0)"
                    )

                    if let cnt = val.content {
                        val.content = try wrap(
                            self.replaceReferenceIn(content: cnt, tree: tree, ref: ref, path: path),
                            message: "While replacing reference in response with code \(mutableResp.statusCode ?? 0)"
                        )
                    }

                    mutableResp.response = .value(val)
                    mutableResponses[i] = mutableResp
                }
            }

            return mutableResponses
    }

    func replaceReferenceIn(
        content: Content,
        tree: OpenAPIASTTree,
        ref: String,
        path: String) throws -> Content {

            var mutContent = content

            for key in mutContent.mediaItems.keys {

                guard var item = mutContent.mediaItems[key] else {
                    continue
                }

                item.schema = try wrap(
                    self.processSchema(schema: item.schema, tree: tree, ref: ref, path: path),
                    message: "While replacing reference in media item \(key)"
                )

                mutContent.mediaItems[key] = item

            }

            return mutContent
    }

    func raplceReferenceIn(
        headers: [String: PossibleReference<Header>],
        tree: OpenAPIASTTree,
        ref: String,
        path: String) throws -> [String: PossibleReference<Header>] {

            var mutHeaders = headers

            for key in headers.keys {

                guard let header = headers[key] else { continue }

                switch header {
                case .reference(let val):
                    let flag = try wrap(
                        self.isNeedToReplaceReference(refToReplace: val.rawValue, tree: tree, ref: ref, path: path),
                        message: "While replacing reference in header \(key.key)"
                    )

                    guard flag else {
                        continue
                    }

                    mutHeaders[key] = .reference(.init(Constants.ASTNodeReference.todo))
                case .value(var val):
                    let schema = try wrap(
                        self.processSchema(schema: val.schema.schema, tree: tree, ref: ref, path: path),
                        message: "While replacing reference in header \(key)"
                    )

                    val.schema.schema = schema
                    mutHeaders[key] = .value(val)
                }
            }

            return mutHeaders
    }

    func replaceReferenceInParameters(
        params: [PossibleReference<Parameter>],
        tree: OpenAPIASTTree,
        ref: String,
        path: String) throws -> [PossibleReference<Parameter>] {

            var mutableParams = params

            for j in 0..<mutableParams.count {
                let parameter = mutableParams[j]

                switch parameter {
                case .reference(let val):
                    let flag = try self.isNeedToReplaceReference(refToReplace: val.rawValue, tree: tree, ref: ref, path: path)

                    guard flag else { continue }

                    mutableParams[j] = .reference(.init(Constants.ASTNodeReference.todo))
                case .value(var paramVal):

                    switch paramVal.type {
                    case .content:
                        continue
                    case .schema(var val):
                        let res = try self.processSchema(schema: val.schema, tree: tree, ref: ref, path: path)
                        val.schema = res

                        paramVal.type = .schema(val)

                        mutableParams[j] = .value(paramVal)
                    }

                }
            }

            return mutableParams
    }

    func replaceReferenceInSchemas(tree: OpenAPIASTTree, ref: String, path: String) throws -> OpenAPIASTTree {
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

        return mutableTree
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
