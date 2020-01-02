//
//  FromDTOBuilder.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 24/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

/**
 Class for building initialization code for concrete property for DTOConvertible.from method from NodeKit Entity
*/
public class FromDTOBuilder: DTOBuilder {

    /**
     Method for building concreate initialization piece of code.

     Example

     This method will return "model.newPassword" for (type: .plain, name: "newPassword", isOptional: false) parameters. This resulted
     string is supposed to be used as parameter for .from method as in snippet below.


    ```

     public static func from(dto model: PasswordEntity.DTO) throws -> PasswordEntity {
         return PasswordEntity(newPassword: model.newPassword,
                               oldPassword: model.oldPassword)
     }

    ```

    */
    func buildString(for type: Type, with name: String, isOptional: Bool) -> String {
        switch type {
        case .plain:
            return "model.\(name)"
        case .object:
            return ".from(dto: model.\(name))"
        case .array(let subType):
            switch subType {
            case .plain:
                return "model.\(name)"
            case .object:
                return "try model.\(name)\(isOptional.asOptionalSign).map { try .from(dto: $0) }"
            case .array:
                return "not supported case"
            }
        }
    }

}
