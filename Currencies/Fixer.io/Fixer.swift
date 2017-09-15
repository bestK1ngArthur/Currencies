//
//  Fixer.swift
//  Currencies
//
//  Created by Artem Belkov on 14/09/2017.
//  Copyright © 2017 Artem Belkov. All rights reserved.
//

import Foundation

typealias Currency = String
typealias Rate = Double
typealias RateList = [Currency: Rate]

class Fixer: SimpleNetworking {
    
    let baseURL = "https://api.fixer.io/latest"
    
    static let shared = Fixer()
    
    func getCurrencies(success: (([Currency]) -> ())? = nil, fail: ((Error) -> ())? = nil) {
    
        // 'USD' is used as default value for getting list of currencies
        let baseCurrency = "USD"
        
        getRates(base: baseCurrency, success: { (rates) in
    
            // If success return keys of response
            if let success = success {
                var currencies = Array(rates.keys)
                currencies.insert(baseCurrency, at: 0)
                success(currencies)
            }
            
        }, fail: fail)
    }
    
    func getRates(base: Currency, success: ((RateList) -> ())? = nil, fail: ((Error) -> ())? = nil) {
        
        let parameters = ["base": base]
        
        request(url: baseURL, parameters: parameters, method: .get) { (data, error) in
            
            // If fail
            if let error = error, let fail = fail {
                fail(error)
            }
            
            // If success
            if let data = data {
                // Try to parse json
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                    let rates = json["rates"] as! RateList
                    
                    // Return rate list
                    if let success = success {
                        success(rates)
                    }
                } catch {
                    print("Can't parse JSON")
                }
            }
        }
    }
}
