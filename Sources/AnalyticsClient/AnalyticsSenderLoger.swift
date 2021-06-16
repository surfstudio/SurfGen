//
//  AnalyticsSenderLoger.swift
//
//
//  Created by Александр Кравченков on 07.06.2021.
//

import Foundation
import Common

/// This logger is a combination of any other loger and AnalytcClient
///
/// The idea is send logs to some loger and at the same time send event to analytcs service
///
/// This implementation will create analytcs events from logs with `error`, `warning`, `success` and `fatal` levels
public struct AnalyticsSenderLoger {

    /// Any loger you need to
    private let stdioLogger: Loger
    /// Any kind of analytcs collector
    private let analyticsClient: AnalyticsClient
    /// string representation of CMD args which was sent to SurfGen on start up
    private let initCmdCommandRaw: String

    public init(stdioLogger: Loger, analyticsClient: AnalyticsClient, initCmdCommandRaw: String) {
        self.stdioLogger = stdioLogger
        self.analyticsClient = analyticsClient
        self.initCmdCommandRaw = initCmdCommandRaw
    }
}

extension AnalyticsSenderLoger: Loger {
    public func log(_ level: CommonLogLevel, _ msg: String) {
        self.stdioLogger.log(level, msg)

        switch level {
        case .error, .warning, .success, .fatal:
            self.sendAnalytics(level, msg)
        case .debug, .info:
            break
        }
    }

    private func sendAnalytics(_ level: CommonLogLevel, _ msg: String) {
        let data = [
            "log_level": level.stringValue,
            "message": msg,
            "raw_cmd_command": self.initCmdCommandRaw
        ]

        do {
            self.stdioLogger.debug("Start sending analytics")
            try wrap(self.analyticsClient.logEvent(payload: data), message: "Couldn't send analytics due to errror, message")
            self.stdioLogger.debug("Analytics was sent successfully")
        } catch {
            self.stdioLogger.log(.warning, error.localizedDescription)
        }
    }
}
