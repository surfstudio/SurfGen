//
//  DependencyGraph.swift
//  
//
//  Created by Александр Кравченков on 14.12.2020.
//

import Foundation
import Common

public struct DependencyGraph {

    public class Node {
        public let current: String
        public let filePath: String
        public var next: [Node]?

        public init(current: String, filePath: String, next: [Node]? = nil) {
            self.current = current
            self.next = next
            self.filePath = filePath
        }
    }

    public var root: Node
    private var nodes: [Node]

    public init(root: Node) {
        self.root = root
        self.nodes = [root]
    }

    public func add(node: Node, to parent: Node) throws {
        guard self.nodes.contains(where: { $0 === parent }) else {
            throw CustomError(message: "Node \(node) was added to \(parent) whis is not in the graph")
        }

        if parent.next == nil { parent.next = [] }

        parent.next?.append(node)
    }

    public func search(by value: String) -> Node? {
        return self.recursiveSearch(initNode: self.root, value: value)
    }

    private func recursiveSearch(initNode: Node, value: String) -> Node? {
        guard initNode.current != value else {
            return initNode
        }

        guard let list = initNode.next else {
            return nil
        }

        for node in list {
            guard node.current != value else {
                return node
            }

            guard let result = self.recursiveSearch(initNode: node, value: value) else {
                continue
            }

            return result
        }

        return nil
    }
}
