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
        return Node(token: .encoding(type: try content.mediaEncodingDescription()), [])
    }
}

private extension Content {
    
    func mediaEncodingDescription() throws -> String {
        if jsonSchema != nil {
            return MediaType.json.rawValue
        }
        if formSchema != nil {
            return MediaType.form.rawValue
        }
        if multipartFormSchema != nil {
            return MediaType.multipartForm.rawValue
        }
        guard let encoding =  mediaItems.keys.first else {
            throw GASTBuilderError.undefindedContentBody(mediaItems.keys.description)
        }
        return encoding
    }

}
