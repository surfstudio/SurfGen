//
//  StringExtensions.swift
//  surfgen
//
//  Created by Mikhail Monakov on 06/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

extension String {

    var valueFromUrl: String {
        if let modelName = self.split(separator: "/").last {
            return String(modelName)
        }
        return self
    }

}
