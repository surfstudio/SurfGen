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

enum RequestBody: Equatable {

    enum Encoding: String {
        case json = "application/json"
        case form = "application/x-www-form-urlencoded"
        case multipartForm = "multipart/form-data"
    }

    case model(Encoding, String)
    case array(Encoding, String)
    case dictionary(Encoding, [String: String])
    case multipartModel
    case unsupportedEncoding(String)

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
    private(set) var hasFormEncoding: Bool = false
    private(set) var hasUnsupportedEncoding = false
    private(set) var encodingDescription: String?
    private(set) var isBodyModel = false
    private(set) var isBodyArray = false
    private(set) var bodyModelName: String?
    private(set) var bodyModelType: String?
    private(set) var isBodyDictionary = false
    private(set) var bodyParameters: [ParameterGenerationModel]?

    private(set) var hasUndefinedResponseBody = false
    private(set) var responseModel: String?
    
    init(name: String,
         description: String?,
         path: PathGenerationModel,
         httpMethod: String,
         pathParameters: [ParameterGenerationModel],
         queryParameters: [ParameterGenerationModel],
         requestBody: RequestBody?,
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

        switch requestBody {
        case .model(let encoding, let modelName):
            self.hasFormEncoding = encoding == .form
            self.isBodyModel = true
            self.bodyModelName = modelName.lowercaseFirstLetter()
            self.bodyModelType = ModelType.entity.form(name: modelName)
        case .array(let encoding, let modelName):
            self.hasFormEncoding = encoding == .form
            self.isBodyArray = true
            self.bodyModelName = modelName.lowercaseFirstLetter()
            self.bodyModelType = ModelType.entity.form(name: modelName)
        case .dictionary(let encoding, let dictionary):
            self.hasFormEncoding = encoding == .form
            self.isBodyDictionary = true
            self.bodyParameters = dictionary
                .map { ParameterGenerationModel(name: $0.snakeCaseToCamelCase(),
                                                serverName: $0,
                                                type: $1,
                                                location: .body) }
                .sorted { $0.name < $1.name }
        case .multipartModel:
            self.isBodyModel = true
            self.bodyModelName = Constants.multipartModel.lowercaseFirstLetter()
            self.bodyModelType = Constants.multipartModel
        case .unsupportedEncoding(let encodingDescription):
            self.hasUnsupportedEncoding = true
            self.encodingDescription = encodingDescription
        case .none:
            break
        }

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
