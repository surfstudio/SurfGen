//
//  StencilExtension.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 31/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import Stencil

extension Environment {

    func renderTemplate(_ template: Template, from fileName: String) throws -> String {
        return try renderTemplate(name: fileName, context: template.context)
    }

}
