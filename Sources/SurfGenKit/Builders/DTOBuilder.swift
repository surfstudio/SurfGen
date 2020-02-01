//
//  DTOBuilder.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 02/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

protocol DTOBuilder {
    func buildString(for type: Type, with name: String, isOptional: Bool) -> String
}
