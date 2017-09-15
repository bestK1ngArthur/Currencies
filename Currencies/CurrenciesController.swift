//
//  CurrenciesController.swift
//  Currencies
//
//  Created by Artem Belkov on 14/09/2017.
//  Copyright © 2017 Artem Belkov. All rights reserved.
//

import UIKit

class CurrenciesController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        Fixer.shared.getCurrencies(success: { (currencies) in
            print(currencies)
        }) { (error) in
            print("Load error")
        }
        
        Fixer.shared.getRates(base: "RUB", success: { (rates) in
            print(rates)
        }) { (error) in
            print("Load error")
        }
    }
}

