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
    private let viewModel = CurrencyConverterViewModel(networkService: NetworkService())

    // MARK: Life Cycle
    override func loadView() {
        view = currencyConverterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyConverterView.delegate = self
        viewModel.delegate = self
    }
}

// MARK: - CurrencyConverterViewDelegate
extension CurrencyConverterViewController: CurrencyConverterViewDelegate {
    func didChangeFromCurrency(_ currency: String) {
        viewModel.setFromCurrency(currency)
    }
    
    func didChangeToCurrency(_ currency: String) {
        viewModel.setToCurrency(currency)
    }
    
    func didChangeAmount(_ amount: String) {
        viewModel.setAmount(amount)
    }
}

// MARK: - CurrencyConverterViewModelDelegate
extension CurrencyConverterViewController: CurrencyConverterViewModelDelegate {
    func didUpdateConversion(amount: Double, currency: String) {
        currencyConverterView.setConvertedAmount("\(String(format: "%.2f", amount)) \(currency)")
    }
    
    func didFailWithError(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Retry", style: .default) { [weak self] _ in
            self?.viewModel.fetchConversion()
        })
        present(alert, animated: true)
    }
}
