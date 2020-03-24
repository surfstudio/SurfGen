//
//  FileLoader.swift
//  SurfGen
//
//  Created by Mikhail Monakov on 24/03/2020.
//

import Foundation

enum FileLoaderError: Error {
    case incorrectURL(String)
    case cantLoadFile(String)
}

extension FileLoaderError: LocalizedError {

    public var errorDescription: String? {
        switch self {
        case .incorrectURL(let url):
            return "Provided: \(url) is not a valid URL"
        case .cantLoadFile(let reason):
            return "Can not load file. \nReason: \(reason)"
        }
    }

}

final class FileLoader {

    // MARK: - Constants

    private enum Constants {
        static let gitlabTokenHeader = "PRIVATE-TOKEN"
        static let successCode = 200
    }

    // MARK: - Internal methods

    func loadFile(_ urlString: String, token: String? = nil) throws -> String {
        guard let url = URL(string: urlString) else {
            throw FileLoaderError.incorrectURL(urlString)
        }

        var request = URLRequest(url: url)
        if let token = token {
            request.addValue(token, forHTTPHeaderField: Constants.gitlabTokenHeader)
        }

        let sm = DispatchSemaphore(value: 0)
        let session = URLSession(configuration: URLSessionConfiguration.default)

        var resultFile: String?
        var resultError: Error?
        let task: URLSessionDataTask = session.dataTask(with: request) { (data, response, error) -> Void in
            resultError = error
            let status = (response as? HTTPURLResponse)?.statusCode
            switch status {
            case Constants.successCode?:
                if let data = data {
                    resultFile = String(decoding: data, as: UTF8.self)
                }
            default:
                resultError = error ?? FileLoaderError.cantLoadFile("Response returned code: \(String(describing: status))")
            }
            sm.signal()
        }
        task.resume()
        _ = sm.wait(timeout: .distantFuture)

        if let error = resultError {
            throw error
        }

        if let file = resultFile {
            return file
        }

        throw FileLoaderError.cantLoadFile("Could not decode response for url: \(url)")
    }

}
