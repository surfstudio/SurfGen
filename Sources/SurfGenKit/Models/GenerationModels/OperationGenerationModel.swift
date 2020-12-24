//
//  OperationGenerationModel.swift
//  
//
//  Created by Dmitry Demyanov on 04.11.2020.
//

enum HttpMethod: String {
    case get
    case post
    case patch
    case put
    case delete
    
    var name: String {
        switch self {
        case .get, .post, .delete:
            return self.rawValue
        case .put, .patch:
            return "update"
        }
    }
}

public struct OperationGenerationModel {
    
    private enum Constants {
        static let multipartModel = "MultipartModel"
    }

    let name: String
    let hasDescription: Bool
    let description: String?
    let path: PathGenerationModel
    let httpMethod: String
    let hasPathParameters: Bool
    let pathParameters: [ParameterGenerationModel]
    let hasQueryParameters: Bool
    let queryParameters: [ParameterGenerationModel]

    let hasBody: Bool
    var requestBody: RequestBodyGenerationModel?
    var responseBody: ResponseBodyGenerationModel
    
    init(name: String,
         description: String?,
         path: PathGenerationModel,
         httpMethod: String,
         pathParameters: [ParameterGenerationModel],
         queryParameters: [ParameterGenerationModel],
         requestBody: RequestBodyGenerationModel.BodyType?,
         responseBody: ResponseBody) {
        self.name = name
        self.hasDescription = description != nil
        self.description = description
        self.path = path
        self.httpMethod = httpMethod
        self.hasPathParameters = !pathParameters.isEmpty
        self.pathParameters = pathParameters
        self.hasQueryParameters = !queryParameters.isEmpty
        self.queryParameters = queryParameters
        self.hasBody = requestBody != nil
        self.requestBody = RequestBodyGenerationModel(type: requestBody)
        self.responseBody = ResponseBodyGenerationModel(response: responseBody)
    }

}
