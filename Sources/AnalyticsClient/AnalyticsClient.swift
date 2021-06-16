//
//  AnalyticsClient.swift
//  
//
//  Created by Александр Кравченков on 03.06.2021.
//

import Foundation

/// Default inteface for any analytics collector
///
/// It's strongly recommended to conform your custom collector to this interface
///
/// If you need to use this client in SurfGen code, but the interface doesn't convince your needs, then you will need to create a pipeline
/// like in `Logstash`
///
/// For example, you create your own `CustomClient` with `logEvent(payload: [String: Any])`
///
/// And then you create nested pipeline which is sent events (this `CustomSender` is a real client)
/// and this class don't have to implement `AnalyticsClient` interface.
///
/// Inside `CustomClient.logEvent(payload:)` you do mapping (or/and reducing) from dictionary to your custom type and then send it to `CustomSender`
///
/// The pipeline will look like:
///
/// `<SurfGenCode>  -> send raw logs -> CustomClient -> map/reduce -> CustomSender -> send logs in some way -> <Log Keeper>`
public protocol AnalyticsClient {

    /// This method whould be synchronious
    /// So if you need to call it in async way then you should wrap it in `DispatchQueue.asnyc {...}` block
    ///
    /// Can throws any kind of exception and it's up to you to handle them
    func logEvent(payload: [String: Any]) throws
}

