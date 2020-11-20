//
//  GASTContentNodeBuilder.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 13/03/2020.
//

import Swagger
import SurfGenKit

final class GASTContentNodeBuilder {

    func buildObjectContentSubnodes(for object: ObjectSchema) throws -> ASTNode {
        return Node(token: .content, try buildSubnodes(for: object))
    }

    func buildEnumContentSubnodes(for schema: ComponentObject<Schema>) throws -> ASTNode {
        if let values = schema.value.metadata.enumValues as? [String]  {
            return Node(token: .content, values.map { Node(token: .value($0), []) })
        }

        if let values = schema.value.metadata.enumValues as? [Int]  {
            return Node(token: .content, values.map { Node(token: .value(String($0)), []) })
        }
        throw SurfGenError(nested: GASTBuilderError.incorrectEnumObjectConfiguration(schema.name),
                           message: "Could not build enum content subnodes")
    }
    
    func buildServiceContentSubnodes(with operations: [Operation]) throws -> ASTNode {
        return Node(token: .content, try operations.map {
            try wrap(GASTOperationNodeBuilder().buildMethodNode(for: $0),
                     with: "Could not build service conent subnodes")
            
        })
    }

    private func buildSubnodes(for object: ObjectSchema) throws -> [ASTNode] {
        let builder = GASTFieldNodeBuilder()
        var fieldNodes = [ASTNode]()
        for property in object.properties {
            var fieldSubNodes = [
                Node(token: .name(value: property.name), []),
                try wrap(builder.buildFieldType(for: property.schema),
                         with: "Could not build object content subnodes")
            ]
            if let description = property.schema.metadata.description {
                fieldSubNodes.append(Node(token: .description(description), []))
            }
            fieldNodes.append(Node(token: .field(isOptional: !property.required), fieldSubNodes))
        }
        return fieldNodes
    }

}
