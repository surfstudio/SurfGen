//
//  File.swift
//  
//
//  Created by Александр Кравченков on 27.12.2020.
//

import Foundation

/// Describes a single request body
public struct RequestBodyNode {
    public let description: String?
    public let content: [MediaTypeObjectNode]
    public let isRequired: Bool

    public init(description: String?,
                content: [MediaTypeObjectNode],
                isRequired: Bool) {
        self.description = description
        self.content = content
        self.isRequired = isRequired
    }
}
