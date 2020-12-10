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

enum ResponseBody: Equatable {
    case model(String)
    case arrayOf(String)
    case unsupportedObject
}

public struct OperationGenerationModel {
    
    private enum Constants {
        static let multipartModel = "MultipartModel"
        static let emptyResponse = "Void"
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

    private(set) var hasUndefinedResponseBody = false
    private(set) var responseModel: String?
    
    init(name: String,
         description: String?,
         path: PathGenerationModel,
         httpMethod: String,
         pathParameters: [ParameterGenerationModel],
         queryParameters: [ParameterGenerationModel],
         requestBody: RequestBodyGenerationModel.BodyType?,
         responseBody: ResponseBody?) {
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

        switch responseBody {
        case .model(let modelName):
            self.responseModel = ModelType.entity.form(name: modelName)
        case .arrayOf(let modelName):
            self.responseModel = ModelType.entity.form(name: modelName).asArray()
        case .unsupportedObject:
            self.hasUndefinedResponseBody = true
        case .none:
            self.responseModel = Constants.emptyResponse
        }
    }

}
