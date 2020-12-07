//
//  GASTMediaContentNodeBuilder.swift
//  
//
//  Created by Dmitry Demyanov on 22.10.2020.
//

import Swagger
import SurfGenKit

final class GASTMediaContentNodeBuilder {
    
    func buildMediaContentNode(with content: Content) throws -> ASTNode {
        let encodingNode = try wrap(GASTEncodingNodeBuilder().buildEncodingNode(for: content),
                                    with: "Could not create encoding node for operation")
        if let encodedSchema = content.anySchema {
            return try Node(token: .mediaContent, [encodingNode, subNodeForEncoded(schema: encodedSchema)])
        } else {
            return Node(token: .mediaContent, [encodingNode])
        }
    }

    private func subNodeForEncoded(schema: Schema) throws -> ASTNode {
        switch schema.type {
        case .object(let object):
            return Node(token: .type(name: ASTConstants.object), try object.properties.map { property in
                guard let propertyType = property.schema.type.typeName else {
                    throw SurfGenError(nested: GASTBuilderError.undefindedContentBody(schema.type.description),
                                       message: "Could not determine fields of request body object")
                }
                return Node(token: .field(isOptional: !property.required), [
                    Node(token: .name(value: property.name), []),
                    try GASTTypeNodeBuilder().buildTypeNode(for: property.schema)
                ])
            })
        case .array(let array):
            guard case let .single(subSchema) = array.items, let modelName = subSchema.type.modelName else {
                throw SurfGenError(nested: GASTBuilderError.undefindedContentBody(schema.type.description),
                                   message: "Could not determine array model name for body")
            }
            return Node(token: .type(name: ASTConstants.array), [
                Node(token: .type(name: modelName), [])
            ])
        default:
            guard let typeName = schema.type.modelName else {
                throw SurfGenError(nested: GASTBuilderError.undefindedContentBody(schema.type.description),
                                   message: "Could not determine model name for body")
            }
            return Node(token: .type(name: typeName), [])
        }
    }

}

private extension Content {

    var anySchema: Schema? {
        return jsonSchema ?? formSchema ?? multipartFormSchema
    }

}
