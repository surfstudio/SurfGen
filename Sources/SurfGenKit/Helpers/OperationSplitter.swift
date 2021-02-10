//
//  OperationSplitter.swift
//  
//
//  Created by Dmitry Demyanov on 27.11.2020.
//

class OperationSplitter {

    /// Splits one operation with `oneOf` request body type into several operations with single request bodies
    func splitMultipleBodyOptions(operation: OperationGenerationModel) -> [OperationGenerationModel] {
        guard let options = operation.requestBody?.multipleOptions else {
            return [operation]
        }
        return options.map { bodyOption in
            var copy = operation
            copy.requestBody = RequestBodyGenerationModel(type: bodyOption)
            return copy
        }
    }

}
