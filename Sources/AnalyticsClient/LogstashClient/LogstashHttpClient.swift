//
//  LogstashHttpClient.swift
//  
//
//  Created by Александр Кравченков on 03.06.2021.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

/// Very simple client which is add property `"sender": "SurfGen"` to input payload
/// Then serialize it to JSON and send given to Logstash endpoint.
///
/// Client is syncronious and if server didn't reply in 5 seconds then connection will be closed and error will be thrown.
/// If response's status code isn't 200 the error will be thrown
public struct LogstashHttpClient {

    enum Err: Error {
        case ServerDidNotReply
        case BadResponse
        case ServerReplyWithBadCode(Int)
    }

    /// This uri is used `AS IS` to send requests
    /// It means that requests will be sent exactly to this URI
    public let endpointUri: URL
    /// This is user-defined payload which will be send to analytcs
    public let staticPayload: [String: String]

    public init(endpointUri: URL, payload: [String: String]) {
        self.endpointUri = endpointUri
        self.staticPayload = payload
    }
}


extension LogstashHttpClient: AnalyticsClient {

    public func logEvent(payload: [String : Any]) throws {
        var payload = payload
        payload["sender"] = "SurfGen"
        payload["user_defined"] = self.staticPayload

        let jsonData = try JSONSerialization.data(withJSONObject: payload, options: .fragmentsAllowed)

        var urlRequest = URLRequest(url: endpointUri)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonData

        var respStatusCode: Int?
        var err: Error?

        let wg = DispatchGroup()

        wg.enter()

        let task = URLSession.shared.dataTask(with: urlRequest) { _, response, error in

            err = error

            guard let resp = response as? HTTPURLResponse else {
                return
            }

            respStatusCode = resp.statusCode

            wg.leave()
        }

        task.resume()

        _ = wg.wait(timeout: .now() + .seconds(5))

        if let err = err {
            throw err
        }

        guard let guardedRespStatusCode = respStatusCode else {
            throw Err.ServerDidNotReply
        }

        guard guardedRespStatusCode == 200 else {
            throw Err.ServerReplyWithBadCode(guardedRespStatusCode)
        }
    }
}
