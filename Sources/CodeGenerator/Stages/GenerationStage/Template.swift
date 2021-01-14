//
//  Template.swift
//  
//
//  Created by Dmitry Demyanov on 13.01.2021.
//

import Foundation

/// This model keeps information about templates locations and destination for each generated file
public struct Template: Decodable {
    
    public let templatePath: String
    public let destinationPath: String
}
