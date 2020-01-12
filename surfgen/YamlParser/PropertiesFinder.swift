//
//  PropertiesFinder.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 13/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import Swagger

final class PropertiesFinder {

   /**
    Method finds all properties for provided schema. As it could contain references and groups it recursively goes through all depended schemas
    */
   func findProperties(for schema: Schema) -> (required: [Property], optional: [Property]) {
       switch schema.type {
       case .object(let objectSchema):
           return (objectSchema.optionalProperties, objectSchema.requiredProperties)
       case .array(let arraySchema):
           switch arraySchema.items {
           case .single(let singleSchema):
               return findProperties(for: singleSchema)
           default:
               return ([], [])
           }
       case .reference(let refSchema):
           return findProperties(for: refSchema.value)
       case .group(let groupSchema) where groupSchema.type == .all:
           return groupSchema.schemas.map { findProperties(for: $0) }
                                     .reduce(([], [])) { (result, curr) -> ([Property], [Property]) in
               return (result.required + curr.required, result.optional + curr.optional)
           }
       default:
           return ([], [])
       }
   }

}

