//
//  File.swift
//  
//
//  Created by Александр Кравченков on 27.12.2020.
//

import Foundation
import GASTTree
import Common

/// This class can resolve references - replace reference to `Schema` with  `Schema` itself
/// It can resolve local references and references to another files
/// It can determine referece cycles and handle them by replacing reference to already resolved schema with its name
///
/// **WARNING**
/// **ISN'T THREAD SAFE**
public class Resolver {

    struct Ref: Equatable {
        let pathToFile: String
        let refValue: String
    }

    struct ResolvedRef: Equatable {
        let ref: Ref
        let objectNode: SchemaObjectNode

        static func == (lhs: Resolver.ResolvedRef, rhs: Resolver.ResolvedRef) -> Bool {
            return lhs.ref == rhs.ref
        }
    }

    private let logger: Loger?

    private var resolvedObjects = [ResolvedRef]()

    public init(logger: Loger? = nil) {
        self.logger = logger
    }

    public func resolveParameter(ref: String, node: DependencyWithTree, other: [DependencyWithTree]) throws -> ParameterModel {

        let res = ref.split(separator: "#")

        let intRef = Ref(pathToFile: node.dependency.pathToCurrentFile, refValue: ref)

        guard !resolvedObjects.contains(where: { $0.ref == intRef }) else {
            let refStack = resolvedObjects.map { $0.ref }
            throw CommonError(message: "There is a reference cycle which is found for reference \(ref) from file \(node.dependency.pathToCurrentFile)\n\tCallStack:\n\t\t\(buildDebugDescription(for: refStack))")
        }

        if res.count == 2 {
            let dep = try self.resolveRefToAnotherFile(ref: ref, node: node, other: other)
            let res =  try self.resolveParameter(ref: "#\(res[1])", node: dep, other: other)
            return res
        }

        let resolved: ParameterNode = try node.tree.resolve(reference: String(ref))

        resolvedObjects.append(ResolvedRef(ref: intRef, objectNode: resolved.type.schema))
        defer {
            resolvedObjects.removeLast()
        }

        switch resolved.type.schema.next {
        case .object:
            throw CommonError(message: "Parameter \(resolved.name) from file '\(node.dependency.pathToCurrentFile) contains object definition in type. This is unsupported.")
        case .enum:
            throw CommonError(message: "Parameter \(resolved.name) from file '\(node.dependency.pathToCurrentFile) contains enum definition in type. This is unsupported.")
        case .group:
            throw CommonError(message: "Parameter \(resolved.name) from file '\(node.dependency.pathToCurrentFile) contains group definition in type. This is unsupported.")
        case .simple(let simple):
            return .init(componentName: resolved.componentName,
                         name: resolved.name,
                         location: resolved.location,
                         type: .primitive(simple.type),
                         description: resolved.description,
                         isRequired: resolved.isRequired)
        case .reference(let newRef):
            return .init(componentName: resolved.componentName,
                         name: resolved.name,
                         location: resolved.location,
                         type: .reference(try resolveSchema(ref: newRef, node: node, other: other)),
                         description: resolved.description,
                         isRequired: resolved.isRequired)
        case .array(let arr):
            return .init(componentName: resolved.componentName,
                         name: resolved.name,
                         location: resolved.location,
                         type: .array(try self.resolve(arr: arr, node: node, other: other)),
                         description: resolved.description,
                         isRequired: resolved.isRequired)
        }
    }

    public func resolveSchema(ref: String, node: DependencyWithTree, other: [DependencyWithTree]) throws -> SchemaType {

        let intRef = Ref(pathToFile: node.dependency.pathToCurrentFile, refValue: ref)

        if let alreadyResolvedRef = resolvedObjects.first(where: { $0.ref == intRef }) {
            logger?.warning("Reference cycle was detected in \(node.dependency.pathToCurrentFile). Make sure it is expected and really reasonable with your project's business logic. Cycle description:\n\t\t\(buildCycleDebugDescription(for: intRef))")
            return try useAlreadyResolved(object: alreadyResolvedRef.objectNode)
        }

        let res = ref.split(separator: "#")

        if res.count == 2 {
            let res = try wrap(self.resolveAnotherFile(ref: ref, node: node, other: other),
                               message: "While resolving \(ref)")
            return res
        }

        let resolved: SchemaObjectNode = try wrap(node.tree.resolve(reference: String(ref)),
                                                  message: "While resolving \(ref) in \(node.dependency.pathToCurrentFile)")
        resolvedObjects.append(ResolvedRef(ref: intRef, objectNode: resolved))
        defer {
            resolvedObjects.removeLast()
        }

        switch resolved.next {
        case .enum(let val):
            guard let type = PrimitiveType(rawValue: val.type) else {
                throw CommonError(message: "Enum \(val.name) contains type which is not primitive -- \(val.type)")
            }
            return .enum(.init(name: val.name, cases: val.cases, type: type, description: val.description))
        case .simple(let val):
            return .alias(.init(name: val.name, type: val.type))
        case .object(let val):
            return try self.resolveObject(val: val, node: node, other: other)
        case .reference(let ref):
            return try resolveSchema(ref: ref, node: node, other: other)
        case .array(let arr):
            return SchemaType.array(try self.resolve(arr: arr, node: node, other: other))
        case .group(let val):
            return try self.resolve(group: val, node: node, other: other)
        }
    }

    private func resolveAnotherFile(ref: String, node: DependencyWithTree, other: [DependencyWithTree]) throws -> SchemaType {
        let dep = try self.resolveRefToAnotherFile(ref: ref, node: node, other: other)
        let splited = ref.split(separator: "#")

        guard splited.count == 2 else {
            throw CommonError(message: "Reference whics was used in resolving dependency in another file")
        }

        return try self.resolveSchema(ref: "#\(splited[1])", node: dep, other: other)
    }

    public func resolveRefToAnotherFile(ref: String, node: DependencyWithTree, other: [DependencyWithTree]) throws -> DependencyWithTree {
        guard let pathToDependencyFile = node.dependency.dependecies[ref] else {
            throw CommonError(message: "Can't find dependency with ref \(ref) in \(node.dependency.pathToCurrentFile)")
        }

        guard let res = other.first(where: { $0.dependency.pathToCurrentFile == pathToDependencyFile }) else {
            throw CommonError(message: "Can't find dependency which is located in file at path \(pathToDependencyFile)")
        }

        return res
    }

    private func resolveObject(val: SchemaModelNode, node: DependencyWithTree, other: [DependencyWithTree]) throws -> SchemaType {
        let propertyTypeUnwrapper = { (input: Referenced<PrimitiveType>) -> PropertyModel.PossibleType in
            switch input{
            case .entity(let val):
                return .primitive(val)
            case .ref(let ref):
                return .reference(try self.resolveSchema(ref: ref, node: node, other: other))
            }
        }

        let arrayItemTypeUnwrapper = { (input: Referenced<PrimitiveType>) -> SchemaArrayModel.PossibleType in
            switch input{
            case .entity(let val):
                return .primitive(val)
            case .ref(let ref):
                return .reference(try self.resolveSchema(ref: ref, node: node, other: other))
            }
        }

        let propertiesMapper = { (property: PropertyNode) -> PropertyModel in

            switch property.type {
            case .array(let arr):
                return .init(name: property.name,
                             description: property.description,
                             type: .array(.init(name: "", itemsType: try arrayItemTypeUnwrapper(arr.itemsType))),
                             isNullable: property.nullable)
            case .simple(let val):
                return .init(name: property.name,
                             description: property.description,
                             type: try propertyTypeUnwrapper(val),
                             isNullable: property.nullable)
            }
        }

        let properties = try val.properties.map(propertiesMapper)

        let res = SchemaObjectModel(name: val.name,
                                    properties: properties,
                                    description: val.description)

        return .object(res)
    }

    private func resolve(group: SchemaGroupNode,
                         node: DependencyWithTree,
                         other: [DependencyWithTree]) throws -> SchemaType {

        let refs = try group.references.map { ref throws -> SchemaGroupModel.PossibleType in
            let resolved = try self.resolveSchema(ref: ref, node: node, other: other)

                switch resolved {
                case .alias:
                    throw CommonError(message: "Group shouldn't contains references on aliases")
                case .enum:
                    throw CommonError(message: "Group shouldn't contains references on enums")
                case .array:
                    throw CommonError(message: "Group shouldn't contains references on arrays")
                case .group(let val):
                    return .group(val)
                case .object(let val):
                    return .object(val)
                }
        }

        return .group(.init(name: group.name, references: refs, type: group.type))
    }

    func resolve(arr: SchemaArrayNode,
                 node: DependencyWithTree,
                 other: [DependencyWithTree]) throws -> SchemaArrayModel {


        let value = try { () -> SchemaArrayModel.PossibleType in
            switch arr.type.next {

            case .object:
                throw CommonError(message: "Array shouldn't contains enum definition")
            case .enum:
                throw CommonError(message: "Array shouldn't contains enum definition")
            case .array:
                throw CommonError(message: "Array shouldn't contains enum definition")
            case .group:
                throw CommonError(message: "Array shouldn't contains enum definition")
            case .simple(let val):
                return .primitive(val.type)
            case .reference(let ref):
                let resolved = try wrap(
                    self.resolveSchema(ref: ref, node: node, other: other),
                    message: "While resolving \(ref) from \(node.dependency.pathToCurrentFile)"
                )
                return .reference(resolved)
            }
        }()

        return .init(name: arr.name, itemsType: value)
    }

    private func useAlreadyResolved(object: SchemaObjectNode) throws -> SchemaType {
        switch object.next {
        case .object(let model):
            return .object(.init(name: model.name, properties: [], description: nil))
        case .group(let group):
            return .group(.init(name: group.name, references: [], type: group.type))
        default:
            throw CommonError(message: "Restoring reference cycles is supported only for objects and groups, \(object.next) cannot form a cycle")
        }
    }

}

// MARK: - Debug message builders

private extension Resolver {

    func buildCycleDebugDescription(for cycledRef: Ref) -> String {
        let refStack = resolvedObjects.map { $0.ref }
        guard let cycledRefIndex = refStack.firstIndex(of: cycledRef) else {
            return ""
        }
        return buildDebugDescription(for: refStack[cycledRefIndex...] + [cycledRef])
    }

    func buildDebugDescription(for referenceStack: [Ref]) -> String {
        return referenceStack.reduce("", { $0 + "--> \($1.pathToFile) : \($1.refValue) " })
    }

}
