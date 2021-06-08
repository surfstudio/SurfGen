//
//  LogstashHttpClient.swift
//  
//
//  Created by Александр Кравченков on 03.06.2021.
//

import Foundation

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
    public let enpointUri: URL
    public let staticPayload: [String: String]

    public init(enpointUri: URL, payload: [String: String]) {
        self.enpointUri = enpointUri
        self.staticPayload = payload
    }
}

extension LogstashHttpClient: AnalyticsClient {
    public func logEvent(payload: [String : Any]) throws {
        var payload = payload
        payload["sender"] = "SurfGen"

        payload = payload.merging(self.staticPayload, uniquingKeysWith: {left, _ in left })

        let jsonData = try JSONSerialization.data(withJSONObject: payload, options: .fragmentsAllowed)

        var urlRequest = URLRequest(url: enpointUri)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = jsonData

        var resp: HTTPURLResponse?
        var err: Error?

        let wg = DispatchGroup()

        wg.enter()

        let task = URLSession.shared.dataTask(with: urlRequest) { _, response, error in

            resp = response as! HTTPURLResponse

            err = error

            wg.leave()
        }

        task.resume()

        _ = wg.wait(timeout: .now() + .seconds(5))

        if let err = err {
            throw err
        }

        guard let resp = resp else {
            throw Err.ServerDidNotReply
        }


        guard resp.statusCode == 200 else {
            throw Err.ServerReplyWithBadCode(resp.statusCode)
        }
    }
}
