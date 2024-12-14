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

    // MARK: Lifecycle
    override func loadView() {
        view = currencyConverterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currencyConverterView.delegate = self
        viewModel.delegate = self
        viewModel.fetchConversion()
        viewModel.startPeriodicUpdates()
    }
    
    deinit {
        viewModel.stopPeriodicUpdates()
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
        let formattedAmount = viewModel.formattedAmount(amount, currency: currency)
        currencyConverterView.setConvertedAmount(formattedAmount)
        
        let formattedLastUpdatedDate = viewModel.formattedLastUpdatedDate(.now)
        currencyConverterView.setLastUpdated(formattedLastUpdatedDate)
    }
    
    func didStartLoading() {
        currencyConverterView.isLoading = true
    }
    
    func didFinishLoading() {
        currencyConverterView.isLoading = false
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
