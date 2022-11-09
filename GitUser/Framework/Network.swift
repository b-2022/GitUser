//
//  Network.swift
//  GitUser
//
//  Created by Boon on 01/11/2022.
//

import UIKit
import Network


//Create protocol to return session
protocol NetworkDelegate: AnyObject {
    func network(connection: Bool)
}

typealias completionNetwork = (_ connection: Bool) -> ()

//Monitor netowrk connection with NWPathMonitor
class Network: NSObject {
    static let shared = Network()
    
    var monitor: NWPathMonitor?
    let queue = DispatchQueue(label: "NetworkMonitoring")
    
    
    //Create var completion to store closure
    var completion: completionNetwork?
    weak var delegate: NetworkDelegate?
    
    func handler(){
        monitor?.pathUpdateHandler = { path in
            if path.status == .satisfied {
                print("Got COnnection")
                self.completion?(true)
                self.delegate?.network(connection: true)
            }
            else if (path.status == .unsatisfied){
                print("No Connection")
                self.completion?(false)
                self.delegate?.network(connection: false)
            }
        }
    }
    
    func startMonitor(_ completion: completionNetwork? = nil){
        self.completion = completion
        

        if monitor == nil {
            monitor = NWPathMonitor()
        }
        
        handler()
        
        if monitor?.queue == nil {
            monitor?.start(queue: queue)
        }
    }
    
    func stopMonitor(){
        monitor?.cancel()
        monitor = nil
    }
}
