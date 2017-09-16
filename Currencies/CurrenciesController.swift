//
//  CurrenciesController.swift
//  Currencies
//
//  Created by Artem Belkov on 14/09/2017.
//  Copyright © 2017 Artem Belkov. All rights reserved.
//

import UIKit

class CurrenciesController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var baseCurrencyPicker: UIPickerView!
    @IBOutlet weak var requiredCurrencyPicker: UIPickerView!
    
    @IBOutlet weak var indicator: Indicator!
    
    @IBOutlet weak var rateLabel: UILabel!
    @IBOutlet weak var valueField: UITextField!
    
    enum CurrencyPicker: Int {
        case base     = 0
        case required = 1
    }
    
    var baseCurrencies: [Currency] = []
    var requiredCurrencies: [Currency] = []
    
    var rates: RateList = [:]
    var baseCurrency: Currency = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        indicator.start()
        
        Fixer.shared.getCurrencies(success: { (currencies) in
            
            self.indicator.stop()
            
            self.baseCurrencies = currencies
            
            DispatchQueue.main.async {
                self.baseCurrencyPicker.reloadAllComponents()
                self.baseCurrency = currencies[self.baseCurrencyPicker.selectedRow(inComponent: 0)]
                self.updateRecuiredCurrencies(base: self.baseCurrency)
            }
            
        }) { (error) in
            print("Load currencies error")
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
            count = baseCurrencies.count
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
            let currency = baseCurrencies[row]
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
            baseCurrency = self.baseCurrencies[row]
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
    
    // MARK: UITextField
    
    @IBAction func valueChanged(_ sender: UITextField) {
        updateRateLabel(currency: requiredCurrencies[requiredCurrencyPicker.selectedRow(inComponent: 0)])
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        updateRateLabel(currency: requiredCurrencies[requiredCurrencyPicker.selectedRow(inComponent: 0)])
        textField.resignFirstResponder()
        
        return true
    }

    
    // MARK: Helpers
    
    func updateRecuiredCurrencies(base: Currency) {
        
        indicator.start()
        
        Fixer.shared.getRates(base: base, success: { (rates) in
            
            self.indicator.stop()
            
            self.rates = rates
            self.requiredCurrencies = Array(rates.keys)
            
            DispatchQueue.main.async {
                self.requiredCurrencyPicker.reloadAllComponents()
                self.updateRateLabel(currency: self.requiredCurrencies[self.requiredCurrencyPicker.selectedRow(inComponent: 0)])
            }
            
        }) { (error) in
            print("Load rates error")
        }
    }
    
    func updateRateLabel(currency: Currency) {
        
        var value: Rate?
        if let string = valueField.text {
            
            value = Double(string)
            
            if value == nil {
                value = 1
                valueField.text = "1"
            }
            
        } else {
            value = 1
            valueField.text = "1"
        }
        
        let rateValue = rates[currency] ?? 0
        let incomeValue = value ?? 1.0
        rateLabel.text = "\(rateValue * incomeValue)"
    }
}

