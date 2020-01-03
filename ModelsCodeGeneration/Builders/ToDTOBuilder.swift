//
//  ToDTOBuilder.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 24/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

public class ToDTOBuilder: DTOBuilder {

    /**
     Method for building concreate initialization piece of code.

     Example

     This method will return "geoPosition.toDTO()" for (type: .object, name: "geo_position", isOptional: false) parameters. This resulted
     string is supposed to be used as parameter for .toDTO method as in snippet below.


    ```
     public func toDTO() throws -> ShopLocationEntry {
             return try .init(region: region,
                              city: city,
                              address: address,
                              floor: floor,
                              sector: sector,
                              geo_position: geoPosition.toDTO())
         }
     }

    ```

    */
    func buildString(for type: Type, with name: String, isOptional: Bool) -> String {
        switch type {
        case .plain:
            return name.snakeCaseToCamelCase()
        case .object:
            return "\(name.snakeCaseToCamelCase())\(isOptional.asOptionalSign).toDTO()"
        case .array(let subType):
            switch subType {
            case .plain:
                return name.snakeCaseToCamelCase()
            case .object:
                return "\(name.snakeCaseToCamelCase())\(isOptional.asOptionalSign).toDTO()"
            case .array:
                return "not supported case"
            }
        }
    }

}
