//
//  ASTToken.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 19/10/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public enum ASTToken: Equatable {
    case name(value: String)
    case decl
    case content
    case field(isOptional: Bool)
    case type(name: String)
    case root
    case description(String)
    case value(String)
    case operation
    case path(value: String)
    case encoding(type: String)
    case location(type: String)
    case mediaContent
    case parameters
    case parameter(isOptional: Bool)
    case requestBody(isOptional: Bool)
    case responseBody

    public static func ==(lhs: ASTToken, rhs: ASTToken) -> Bool {
        switch (lhs, rhs) {
        case (.name, .name),
             (.decl, .decl),
             (.content, .content),
             (.field, .field),
             (.type, .type),
             (.description, .description),
             (.root, .root),
             (.value, .value),
             (.operation, .operation),
             (.path, .path),
             (.encoding, .encoding),
             (.location, .location),
             (.mediaContent, .mediaContent),
             (.parameters, .parameters),
             (.parameter, .parameter),
             (.requestBody, .requestBody),
             (.responseBody, .responseBody):
            return true
        default:
            return false
        }
    }

}
