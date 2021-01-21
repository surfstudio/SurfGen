//
//  Array.swift
//  
//
//  Created by Dmitry Demyanov on 14.01.2021.
//

import Foundation

extension Array where Element: Hashable {

    public func uniqueElements() -> [Element] {
        return Array(Set(self))
    }

}
