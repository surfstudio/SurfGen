//
//  ArrayExtension.swift
//  YamlParser
//
//  Created by Mikhail Monakov on 19/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

extension Array {

    func apply(_ block: (Self) -> Self) -> Self {
       return block(self)
    }

}
