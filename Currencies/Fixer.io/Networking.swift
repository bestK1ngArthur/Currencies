//
//  Networking.swift
//  Currencies
//
//  Created by Artem Belkov on 14/09/2017.
//  Copyright © 2017 Artem Belkov. All rights reserved.
//

import Foundation

class Networking {

    public enum Method: String {
        case get = "GET"
        case post = "POST"
        case put = "PUT"
    }
    
    public func request(url: String, parameters: [String: Any]?, method: Method, completion: ((Data?, Error?) -> ())? = nil) {
        
        // Try to compose URL
        let url = fullURL(baseURL: url, parameters: parameters)
        if let url = url {
            
            // Create request
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            
            // Start request task
            let task = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                
                // Return data on completion
                if let completion = completion {
                    completion(data, error)
                }
            })
            task.resume()
            
        } else {
            print("Networking: Can't create right URL")
        }
    }
    
    // MARK: Helpers
    
    private func fullURL(baseURL: String, parameters: [String: Any]?) -> URL? {
        var urlString = baseURL

        if let parameters = parameters {
            urlString += "?"
            for key in parameters.keys {
                urlString += "\(key)=\(String(describing: parameters[key]!))&"
            }
            urlString.remove(at: urlString.index(before: urlString.endIndex))
        }
        
        return URL(string: urlString)
    }
}
