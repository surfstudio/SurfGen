//
//  GASTFieldNodeBuilder.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 13/03/2020.
//

import Swagger
import SurfGenKit

/**
TODO:
one case for plain type which is an enum is not handled as enum
because it not quite obvious what to do with it
Example:
```
FeedComponent:
properties:
  id:
    $ref: "#/components/schemas/Id"
  type:
    type: string
    description: Тип элемента в ленте. В зависимости от типа может приходить разный контент.
    enum:
      - "banners"
      - "stories"
      - "products"
  content:
    $ref: "#/components/schemas/FeedComponentContent"
required:
  - id
  - type
  - content


```
There is not enum name so we can not genenerate and track all such cases in models
*/

final class GASTFieldNodeBuilder {

    func buildFieldType(for schema: Schema) throws -> ASTNode {

        // case schema type is plain: Int, String, Double, Bool
        if let typeName = schema.type.typeName {
            return Node(token: .type(name: typeName), [])
        }

        // case schema type is a reference to object/enum
        if let ref = schema.type.reference {
            return Node(token: .type(name: ref.component.isEnum ? ASTConstants.enum : "object"), [Node(token: .type(name: ref.name), [])])
        }

        // case schema type is an array of any type
        if case let .array(arrayObject) = schema.type, case let .single(subSchema) = arrayObject.items {
            return Node(token: .type(name: ASTConstants.array), [try buildFieldType(for: subSchema)])
        }

        throw SurfGenError(nested: GASTBuilderError.undefinedTypeForField(schema.type.description),
                           message: "Could not determine field type")
    }

}
