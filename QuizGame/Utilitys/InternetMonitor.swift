//  InternetMonitor.swift
//  Created by Dominik Hel on 06.11.2021.

//  MARK: - Imports
import Foundation
import Network

//  MARK: - ConnectionTypeEnum
/// Internet connection type.
enum ConnectionTypeEnum {
    /// A style for wifi.
    case wifi
    /// A style for cellular.
    case cellular
    /// A style for ethernet.
    case ethernet
    /// A style for unknown.
    case unknown
}

//  MARK: - Class InternetMonitor
final class InternetMonitor {
    //  MARK: - Constants and variables
    /// Shared property of the InternetMonitor class (singleton).
    static let shared = InternetMonitor()
    /// Property of the NWPathMonitor.
    private let monitor: NWPathMonitor
    /// Property of the ConnectionTypeEnum.
    private(set) var connectionType: ConnectionTypeEnum = .unknown
    /// Property isConnected.
    private(set) var isConnected = false
    
    //  MARK: - Init
    /// Private initializer.
    private init() {
        self.monitor = NWPathMonitor()
    }
    
    //  MARK: - Functions
    /// Starts monitoring internet connection.
    public func startMonitoring() {
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
            self?.getConnectionType(path: path)
        }
    }
    
    /// Stops monitoring internet connection.
    public func stopMonitoring() {
        monitor.cancel()
    }
    
    /// Gets connection type and save it into property connectionType.
    ///
    /// - Parameters:
    ///     - path: An object that contains information about the properties of the network that a connection uses, or that are available to your app.
    private func getConnectionType(path: NWPath) {
        if path.usesInterfaceType(.wifi) {
            connectionType = .wifi
        }
        else if path.usesInterfaceType(.cellular) {
            connectionType = .cellular
        }
        else if path.usesInterfaceType(.cellular) {
            connectionType = .ethernet
        } else {
            connectionType = .unknown
        }
    }
}
