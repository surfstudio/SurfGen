//
//  DependencyAnalyzer.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 08/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

final class DependencyAnalyzer {

    func analyze(declNodes: [YamlNode]) -> (nodesToGenerate: [YamlNode], fakeDecl: [String: YamlNode]) {
        var nodesToGenerate = [YamlNode]()
        var fakeDecl = [String: YamlNode]()

        for declNode in declNodes {
            guard
                case let .decl(name) = declNode.token,
                declNode.subNodes.count == 1,
                let typeNode = declNode.subNodes.first,
                case .type = typeNode.token else {
                    nodesToGenerate.append(declNode)
                    continue
            }
            fakeDecl[name] = typeNode
        }
        return (nodesToGenerate, fakeDecl)
    }

}
