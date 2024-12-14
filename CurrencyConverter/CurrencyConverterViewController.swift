//
//  CurrencyConverterViewController.swift
//  CurrencyConverter
//
//  Created by Migovich on 14.12.2024.
//

import UIKit

class CurrencyConverterViewController: UIViewController {
    
    // MARK: Dependency properties
    private let currencyConverterView = CurrencyConverterView()

    // MARK: Life Cycle
    override func loadView() {
        view = currencyConverterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyConverterView.delegate = self
    }
}

// MARK: - CurrencyConverterViewDelegate
extension CurrencyConverterViewController: CurrencyConverterViewDelegate {
    func didChangeFromCurrency(_ currency: String) {
        print("\(#function): \(currency)")
    }
    
    func didChangeToCurrency(_ currency: String) {
        print("\(#function): \(currency)")
    }
    
    func didChangeAmount(_ amount: String) {
        print("\(#function): \(amount)")
    }
}
