//
//  StringExtension.swift
//  ModelsCodeGeneration
//
//  Created by Mikhail Monakov on 31/12/2019.
//  Copyright © 2019 Surf. All rights reserved.
//

extension String {

    func formOptional(_ isOptional: Bool) -> String {
        return self + isOptional.asOptionalSign
    }

}

