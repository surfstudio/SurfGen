//
//  PropertyModel.swift
//  
//
//  Created by Александр Кравченков on 17.12.2020.
//

import Foundation
import GASTTree

public struct PropertyModel {

    public indirect enum PossibleType {
        case primitive(PrimitiveType)
        case reference(SchemaType)
        case array(PossibleType)
    }

    public let name: String
    public let description: String?
    public let type: PossibleType
}
