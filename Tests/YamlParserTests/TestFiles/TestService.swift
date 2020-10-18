//
//  TestService.swift
//  
//
//  Created by Dmitry Demyanov on 18.10.2020.
//

protocol TestService {
    var rawValue: String { get }
    var matchingPaths: Set<String> { get }
    var pathsWithoutDeprecated: Set<String> { get }
}
