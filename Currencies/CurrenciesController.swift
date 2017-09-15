//
//  CurrenciesController.swift
//  Currencies
//
//  Created by Artem Belkov on 14/09/2017.
//  Copyright © 2017 Artem Belkov. All rights reserved.
//

import UIKit

class CurrenciesController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var baseCurrencyPicker: UIPickerView!
    @IBOutlet weak var requiredCurrencyPicker: UIPickerView!
    @IBOutlet weak var rateLabel: UILabel!
    
    enum CurrencyPicker: Int {
        case base     = 0
        case required = 1
    }
    
    var currencies: [Currency] = []
    var requiredCurrencies: [Currency] = []
    var rates: RateList = [:]
    var baseCurrency: Currency = "USD"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Fixer.shared.getCurrencies(success: { (currencies) in
            self.currencies = currencies
            DispatchQueue.main.async {
                self.baseCurrencyPicker.reloadAllComponents()
            }
            print(currencies)
        }) { (error) in
            print("Load error")
        }
    }
    
    // MARK: UIPickerView
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
    
        var count = 0
        
        switch pickerView.tag {
        case CurrencyPicker.base.rawValue:
            count = currencies.count
            break
        case CurrencyPicker.required.rawValue:
            count = rates.count
            break
        default:
            break
        }
        
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
    
        var attributedString = NSMutableAttributedString()
        let attributes = [NSForegroundColorAttributeName : UIColor.white]
        
        switch pickerView.tag {
        case CurrencyPicker.base.rawValue:
            let currency = currencies[row]
            attributedString = NSMutableAttributedString(string: currency, attributes: attributes)
            break
        case CurrencyPicker.required.rawValue:
            let currency = requiredCurrencies[row]
            attributedString = NSMutableAttributedString(string: currency, attributes: attributes)
            break
        default:
            break
        }
        
        return attributedString
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        switch pickerView.tag {
        case CurrencyPicker.base.rawValue:
            let row = pickerView.selectedRow(inComponent: 0)
            baseCurrency = self.currencies[row]
            updateRecuiredCurrencies(base: baseCurrency)
            return
        case CurrencyPicker.required.rawValue:
            let row = pickerView.selectedRow(inComponent: 0)
            updateRateLabel(currency: requiredCurrencies[row])
            return
        default:
            return
        }
    }
    
    // MARK: Helpers
    
    func updateRecuiredCurrencies(base: Currency) {
        Fixer.shared.getRates(base: base, success: { (rates) in
            self.rates = rates
            self.requiredCurrencies = Array(rates.keys)
            DispatchQueue.main.async {
                self.requiredCurrencyPicker.reloadAllComponents()
            }
        }) { (error) in
            print("Load rates error")
        }
    }
    
    func updateRateLabel(currency: Currency) {
        rateLabel.text = "\(rates[currency] ?? 0)"
    }
}

