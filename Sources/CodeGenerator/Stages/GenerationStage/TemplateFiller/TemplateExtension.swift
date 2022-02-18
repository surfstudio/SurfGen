//
//  TemplateExtension.swift
//  
//
//  Created by volodina on 17.02.2022.
//

import Foundation
import Stencil

extension Extension {

    func registerStringFilter(_ name: String, stringFilter: @escaping (String) -> Any) {
        registerFilter(name) {
            guard let stringValue = $0 as? String else {
                return $0
            }
            return stringFilter(stringValue)
        }
    }
}
