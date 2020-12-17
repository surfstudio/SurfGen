//
//  File.swift
//  
//
//  Created by Александр Кравченков on 17.12.2020.
//

import Foundation

public enum Reference<RefType, NotRefType> {
    case reference(RefType)
    case notReference(NotRefType)
}
