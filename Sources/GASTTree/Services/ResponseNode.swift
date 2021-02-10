//
//  File.swift
//  
//
//  Created by Александр Кравченков on 27.12.2020.
//

import Foundation

public struct ResponseNode {
    public let content: [MediaTypeObjectNode]
    public let description: String?

    public init(description: String?, content: [MediaTypeObjectNode]) {
        self.description = description
        self.content = content
    }
}
