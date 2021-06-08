//
//  AnalyticsSenderLoger.swift
//
//
//  Created by Александр Кравченков on 07.06.2021.
//

import Foundation
import Common

public struct AnalyticsSenderLoger {

    private let stdioLogger: Loger
    private let analyticsClient: AnalyticsClient
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
