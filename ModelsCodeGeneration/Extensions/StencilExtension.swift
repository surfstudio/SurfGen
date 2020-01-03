//
//  StencilExtension.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 31/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

import Stencil

extension Environment {

    func renderTemplate(_ template: Template) throws -> String {
        return try renderTemplate(name: template.fileName, context: template.context)
    }

}
