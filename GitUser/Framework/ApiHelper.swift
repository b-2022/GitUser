//
//  ApiHelper.swift
//  GitUser
//
//  Created by Boon on 01/11/2022.
//

import UIKit


enum API_ENDPOINT: String{
    static let API_DOMAIN = "https://api.github.com/"
    
    case user_list      = "users"
    case user_details   = "users/"
    
    var rawValue: String{
        return "\(API_ENDPOINT.API_DOMAIN)\(self)"
    }
}

typealias CompletionBlock<T: Codable> = (_ result: Bool, _ data: T?, _ status: Error?) -> Void

class ApiHelper: NSObject {
    
    static let shared = ApiHelper()
    let backgroundQueue = DispatchQueue(label: "com.apps.network", qos: .background)
    let semaphore = DispatchSemaphore(value: 1)
    
    fileprivate func startRequest<T: Codable>(request: URLRequest, completion: @escaping CompletionBlock<T>){
        
        backgroundQueue.async {
            self.semaphore.wait()
            
            //Consume API request
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                //Check if response status code not 200, then response failed
                if let urlResponse = response as? HTTPURLResponse {
                    if urlResponse.statusCode != 200 {
                        completion(false, nil, nil)
                        return
                    }
                }
                //Check if error not nil, then response failed
                if error != nil {
                    completion(false, nil, nil)
                    return
                }
                
                //Check if data is empty, then response failed
                guard let _data = data else {
                    completion(false, nil, nil)
                    return
                }

                //Decode data to model, response failed if not success
                let decoder = JSONDecoder()
                do {
                    let model = try decoder.decode(T.self, from: _data)
                    completion(true, model, nil)
                }
                catch {
                    assertionFailure(error.localizedDescription)
                    completion(false, nil, nil)
                }
                
                //Signal semaphore to continue next task
                self.semaphore.signal()
            }
            
            task.resume()
        }
    }
    
    func getUserList(since: Int = 0, completion: @escaping CompletionBlock<[ModelUser]>){

        //Create URL with query paramerter
        var urlComponent = URLComponents(string: "https://api.github.com/users")
        urlComponent?.queryItems = [URLQueryItem(name: "since", value: "\(since)")]
        
        guard let url = urlComponent?.url else{
            completion(false, nil, nil)
            return
        }
        
        //Create URL Request to be used in URLSession
        let request = URLRequest(url: url)
        
        startRequest(request: request, completion: completion)
    }
    
    func getUserDetails(user: String, completion: @escaping CompletionBlock<ModelUser>){
        //Create URL with query paramerter
        var urlComponent = URLComponents(string: "https://api.github.com/users/")
        urlComponent?.path += user
        
        guard let url = urlComponent?.url else{
            completion(false, nil, nil)
            return
        }
        
        //Create URL Request to be used in URLSession
        let request = URLRequest(url: url)
        
        startRequest(request: request, completion: completion)
    }
    
}
