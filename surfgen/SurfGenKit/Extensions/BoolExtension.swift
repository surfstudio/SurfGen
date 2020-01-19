//
//  BoolExtension.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 31/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

extension Bool {

    var asOptionalSign: String {
        return self ? "?" : ""
    }

}
