//
//  GASTEncodingNodeBuilder.swift
//  
//
//  Created by Dmitry Demyanov on 23.10.2020.
//

import Swagger
import SurfGenKit

final class GASTEncodingNodeBuilder {

    func buildEncodingNode(for content: Content) throws -> Node {
        return Node(token: .encoding(type: try content.mediaEncoding().rawValue), [])
    }
}

private extension Content {
    
    func mediaEncoding() throws -> MediaType {
        if jsonSchema != nil {
            return .json
        }
        if formSchema != nil {
            return .form
        }
        if multipartFormSchema != nil {
            return .multipartForm
        }
        throw GASTBuilderError.undefindedContentBody(mediaItems.keys.description)
    }

}
