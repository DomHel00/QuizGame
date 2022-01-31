//  InternetMonitor.swift
//  Created by Dominik Hel on 06.11.2021.


//  MARK: - Imports
import Foundation
import Network

//  MARK: - ConnectionTypeEnum
enum ConnectionTypeEnum {
    case wifi
    case cellular
    case ethernet
    case unknown
}

//  MARK: - Class InternetMonitor
final class InternetMonitor {
    //  MARK: - Constants and variables
    static let shared = InternetMonitor()
    private let monitor: NWPathMonitor
    private(set) var connectionType: ConnectionTypeEnum = .unknown
    private(set) var isConnected = false
    
    //  MARK: - Init
    private init() {
        self.monitor = NWPathMonitor()
    }
    
    //  MARK: - Functions
    public func startMonitoring() {
        monitor.start(queue: DispatchQueue.global())
        monitor.pathUpdateHandler = { [weak self] path in
            self?.isConnected = path.status != .unsatisfied
            self?.getConnectionType(path: path)
        }
    }
    
    public func stopMonitoring() {
        monitor.cancel()
    }
    
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
