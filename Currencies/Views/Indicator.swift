//
//  Indicator.swift
//  Currencies
//
//  Created by Arthur K1ng on 16/09/2017.
//  Copyright © 2017 Artem Belkov. All rights reserved.
//

import UIKit

class Indicator: UILabel {

    var showTime = 0.2
    var delayTime = 1.0
    
    private let currencySymbols = ["$", "¥", "﷼", "₨", "ƒ", "₣‎", "£", "€", "₽"]
    private var isAnimate = false
    
    override func awakeFromNib() {
        
        self.text = ""
        self.alpha = 1

    }

    func start() {
        
        DispatchQueue.main.async {
            self.stop()
            self.isHidden = false
            self.isAnimate = true
            self.makeAnimation()
        }
    }
    
    func stop() {
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delayTime) {
            self.isAnimate = false
            self.isHidden = true
        }
    }
    
    private func randomSymbol() -> String {
        
        let index = Int(arc4random()) % currencySymbols.count
        return currencySymbols[index]
    }
    
    private func makeAnimation() {
        
        // I don't have any time to realize normal animation
        // So I use this recursive hack
        if isAnimate {
            
            self.text = randomSymbol()
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + showTime, execute: {
                self.makeAnimation()
            })
        }
    }
}
