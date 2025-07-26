//
//  NetworkDetector.swift
//  AlfaMovie
//
//  Created by reyhan muhammad on 2025/7/25.
//

import Foundation
import Network
import Combine

//MARK: Courtesy of ChatGPT
//I could use a non Combine version and put it in AppViewModel, but I thought learning Combine while doing this test is not a bad idea

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "NetworkMonitor")
    
    // Publisher that emits network status changes
    private let statusSubject: CurrentValueSubject<Bool, Never>
    var statusPublisher: AnyPublisher<Bool, Never> {
        return statusSubject.eraseToAnyPublisher()
    }
    
    private init() {
        self.monitor = NWPathMonitor()
        self.statusSubject = CurrentValueSubject(true) // Assume online by default
        
        monitor.pathUpdateHandler = { [weak self] path in
            let isConnected = path.status == .satisfied
            self?.statusSubject.send(isConnected)
        }
        
        monitor.start(queue: queue)
    }
    
    deinit {
        monitor.cancel()
    }
}
