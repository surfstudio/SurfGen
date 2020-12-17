//
//  TypeModel.swift
//  
//
//  Created by Александр Кравченков on 17.12.2020.
//

import Foundation
import GASTTree

public indirect enum TypeModel {
    case primitive(String)
    case array(itemType: TypeModel)
    case reference(SchemaModel)
}
