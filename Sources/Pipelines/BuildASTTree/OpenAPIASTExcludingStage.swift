//
//  OpenAPIASTExcludingStage.swift
//  
//
//  Created by Александр Кравченков on 26.10.2021.
//

import Foundation
import Common
import ASTTree

/// Run excleder (`ASTNodeExcluder`) to cut out some parts of AST Tree
/// Use this node to clean or filter your OpenAPI spec before analysis
///
/// **WARNING**
/// Very important node. You have to remember that filepathes in `Dependency` are absolute (from $HOME)
/// So it's up to you make them compatible
public struct OpenAPIASTExcludingStage: PipelineStage {

    private let excluder: ASTNodeExcluder
    private let excludeList: Set<String>
    private let next: AnyPipelineStage<[OpenAPIASTTree]>

    public init(excluder: ASTNodeExcluder, excludeList: Set<String>, next: AnyPipelineStage<[OpenAPIASTTree]>) {
        self.excluder = excluder
        self.excludeList = excludeList
        self.next = next
    }

    public func run(with input: [OpenAPIASTTree]) throws {
        let output = try wrap(
            input.map { try self.excluder.exclude(from: $0, excludeList: self.excludeList) },
            message: "In Excluding AST Nodes stage"
        )

        try self.next.run(with: output)
    }
}
