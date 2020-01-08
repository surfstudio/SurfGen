//
//  GroupResolver.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 08/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

final class GroupResolver {

    func resolve(for declNodes: [YamlNode]) -> [YamlNode] {
        var resolvedDecls = [YamlNode]()
        for decl in declNodes {
            guard case let .group(groupName) = decl.subNodes.first?.token else {
                resolvedDecls.append(decl)
                continue
            }

            if groupName == "allOf" {
                let resolvedProperties = resolve(for: decl, allDecls: declNodes)
                decl.subNodes.removeAll()
                decl.subNodes = resolvedProperties
            }
        }

        return resolvedDecls
    }

    /**
     Returns array of Property nodes
     */
    func resolve(for decl: YamlNode, allDecls: [YamlNode]) -> [YamlNode] {
        var properties = [YamlNode]()

        for subNode in decl.subNodes {

            if case .property = subNode.token {
                properties.append(subNode)
                continue
            }

            if case let .ref(ref) = subNode.token, let declToRetrieve = allDecls.first(where: {
                if case let .decl(name) = $0.token, name == ref {
                    return true
                }
                return false

            }) {
                properties.append(contentsOf: resolve(for: declToRetrieve, allDecls: allDecls))
            }
        }

        return properties
    }

}
