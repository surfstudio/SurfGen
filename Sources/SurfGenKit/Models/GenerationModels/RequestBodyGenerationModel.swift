//
//  RequestBodyGenerationModel.swift
//  
//
//  Created by Dmitry Demyanov on 26.11.2020.
//

struct RequestBodyGenerationModel {

    enum Encoding: String {
        case json = "application/json"
        case form = "application/x-www-form-urlencoded"
        case multipartForm = "multipart/form-data"
    }

    enum BodyType: Equatable {
        case model(Encoding, String, String)
        case array(Encoding, String, String)
        case dictionary(Encoding, [String: String])
        case multipartModel
        case complex([BodyType])
        case unsupportedEncoding(String)
    }

    private enum Constants {
        static let multipartModel = "MultipartModel"
    }

    private(set) var hasFormEncoding: Bool = false
    private(set) var hasUnsupportedEncoding = false
    private(set) var encodingDescription: String?
    private(set) var isModel = false
    private(set) var isArray = false
    private(set) var modelName: String?
    private(set) var modelType: String?
    private(set) var isDictionary = false
    private(set) var parameters: [ParameterGenerationModel]?

    private(set) var multipleOptions: [BodyType]?

    init?(type: BodyType?) {
        switch type {
        case .model(let encoding, let modelName, let modelType):
            self.hasFormEncoding = encoding == .form
            self.isModel = true
            self.modelName = modelName
            self.modelType = modelType
        case .array(let encoding, let modelName, let modelType):
            self.hasFormEncoding = encoding == .form
            self.isArray = true
            self.modelName = modelName
            self.modelType = modelType
        case .dictionary(let encoding, let dictionary):
            self.hasFormEncoding = encoding == .form
            self.isDictionary = true
            self.parameters = dictionary
                .map { ParameterGenerationModel(name: $0.snakeCaseToCamelCase(),
                                                serverName: $0,
                                                type: $1,
                                                location: .body) }
                .sorted { $0.name < $1.name }
        case .multipartModel:
            self.isModel = true
            self.modelName = Constants.multipartModel.lowercaseFirstLetter()
            self.modelType = Constants.multipartModel
        case .unsupportedEncoding(let encodingDescription):
            self.hasUnsupportedEncoding = true
            self.encodingDescription = encodingDescription
        case .complex(let options):
            self.multipleOptions = options
        case .none:
            return nil
        }
    }

}
