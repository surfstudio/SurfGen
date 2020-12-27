//
//  File.swift
//  
//
//  Created by Александр Кравченков on 27.12.2020.
//

import Foundation
import GASTTree
import Common

/// This class can resolve references
/// It can resolve local references and references to another files
/// It can determine referece cycles and throw error with call stack
///
/// **WARNING**
/// **ISN'T THREAD SAFE**
public class Resolver {

    struct Ref {
        let pathToFile: String
        let refValue: String
    }

    var refStack = [Ref]()

    public init() { }

    public func resolveParameter(ref: String, node: DependencyWithTree, other: [DependencyWithTree]) throws -> ParameterModel {

        let res = ref.split(separator: "#")

        let intRef = Ref(pathToFile: node.dependency.pathToCurrentFile, refValue: ref)

        let fromStack = refStack
            .filter { $0.pathToFile == node.dependency.pathToCurrentFile }
            .first { $0.refValue == ref }

        guard fromStack == nil else {

            let stack = self.refStack.reduce("", { $0 + "--> \($1.pathToFile) : \($1.refValue)" })

            throw CustomError(message: "There is a reference cycle which is found for reference \(ref) from file \(node.dependency.pathToCurrentFile)\n\tCallStack:\n\t\t\(stack)")
        }

        self.refStack.append(intRef)

        if res.count == 2 {
            let dep = try self.resolveRefToAnotherFile(ref: ref, node: node, other: other)
            return try self.resolveParameter(ref: "#\(res[1])", node: dep, other: other)
        }

        let resolved: ParameterNode = try node.tree.resolve(reference: String(ref))

        switch resolved.type.schema.next {
        case .object:
            throw CustomError(message: "Parameter \(resolved.name) from file '\(node.dependency.pathToCurrentFile) contains object definition in type. This is unsupported.")
        case .enum:
            throw CustomError(message: "Parameter \(resolved.name) from file '\(node.dependency.pathToCurrentFile) contains enum definition in type. This is unsupported.")
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
        }
    }

    public func resolveSchema(ref: String, node: DependencyWithTree, other: [DependencyWithTree]) throws -> SchemaType {

        let intRef = Ref(pathToFile: node.dependency.pathToCurrentFile, refValue: ref)

        let fromStack = refStack
            .filter { $0.pathToFile == node.dependency.pathToCurrentFile }
            .first { $0.refValue == ref }

        guard fromStack == nil else {

            let stack = self.refStack.reduce("", { $0 + "--> \($1.pathToFile) : \($1.refValue) " })

            throw CustomError(message: "There is a reference cycle which is found for reference \(ref) from file \(node.dependency.pathToCurrentFile)\n\tCallStack:\n\t\t\(stack)")
        }

        self.refStack.append(intRef)

        let res = ref.split(separator: "#")

        if res.count == 2 {
            return try self.resolveAnotherFile(ref: ref, node: node, other: other)
        }

        let resolved: SchemaObjectNode = try node.tree.resolve(reference: String(ref))

        switch resolved.next {
        case .enum(let val):
            guard let type = PrimitiveType(rawValue: val.type) else {
                throw CustomError(message: "Enum \(val.name) contains type which is not primitive -- \(val.type)")
            }
            return .enum(.init(name: val.name, cases: val.cases, type: type))
        case .simple(let val):
            return .alias(.init(name: val.name, type: val.type))
        case .object(let val):
            return try self.resolveObject(val: val, node: node, other: other)
        case .reference(let ref):
            return try resolveSchema(ref: ref, node: node, other: other)
        }
    }

    private func resolveAnotherFile(ref: String, node: DependencyWithTree, other: [DependencyWithTree]) throws -> SchemaType {
        let dep = try self.resolveRefToAnotherFile(ref: ref, node: node, other: other)
        let splited = ref.split(separator: "#")

        guard splited.count == 2 else {
            throw CustomError(message: "Reference whics was used in resolving dependency in another file")
        }

        return try self.resolveSchema(ref: "#\(splited[1])", node: dep, other: other)
    }

    public func resolveRefToAnotherFile(ref: String, node: DependencyWithTree, other: [DependencyWithTree]) throws -> DependencyWithTree {
        guard let pathToDependencyFile = node.dependency.dependecies[ref] else {
            throw CustomError(message: "Can't find dependency with ref \(ref) in \(node.dependency.pathToCurrentFile)")
        }

        guard let res = other.first(where: { $0.dependency.pathToCurrentFile == pathToDependencyFile }) else {
            throw CustomError(message: "Can't find dependency which is located in file at path \(pathToDependencyFile)")
        }

        return res
    }

    private func resolveObject(val: SchemaModelNode, node: DependencyWithTree, other: [DependencyWithTree]) throws -> SchemaType {
        let unwrapper = { (input: Referenced<PrimitiveType>) -> PropertyModel.PossibleType in
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
                             type: try unwrapper(arr.itemsType))
            case .simple(let val):
                return .init(name: property.name,
                             description: property.description,
                             type: try unwrapper(val))
            }
        }

        let properties = try val.properties.map(propertiesMapper)

        let res = SchemaObjectModel(name: val.name,
                                    properties: properties,
                                    description: val.description)

        return .object(res)
    }
}
