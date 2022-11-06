//
//  Network.swift
//  GitUser
//
//  Created by Boon on 01/11/2022.
//

import UIKit
import Network

class Network: NSObject {
    static let shared = Network()
    
    let monitor = NWPathMonitor()
    let queue = DispatchQueue(label: "NetworkMonitoring")
    
    func startMonitor(completion: @escaping (_ connection: Bool) -> Void){
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                completion(true)
            }
            else if (path.status == .unsatisfied){
                completion(false)
            }
            
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring(){
        monitor.cancel()
    }
}
