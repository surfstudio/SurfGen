//
//  YamsParser.swift
//  surfgen
//
//  Created by Mikhail Monakov on 05/01/2020.
//  Copyright © 2020 Surf. All rights reserved.
//

import SwiftyJSON
import Yams

final class YamsParser {

    func load(for spec: String) -> JSON {
        do {
            guard let doc = try Yams.load(yaml: spec) else {
                fatalError("Yams loading returned nil")
            }
            return JSON(doc)
        } catch {
            fatalError(error.localizedDescription)
        }
    }

}



