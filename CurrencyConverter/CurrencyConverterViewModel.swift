//
//  CurrencyConverterViewModel.swift
//  CurrencyConverter
//
//  Created by Migovich on 14.12.2024.
//

import Foundation

protocol CurrencyConverterViewModelDelegate: AnyObject {
    func didUpdateConversion(amount: Double, currency: String)
    func didFailWithError(message: String)
}

class CurrencyConverterViewModel {
    weak var delegate: CurrencyConverterViewModelDelegate?
    
    private let networkService: NetworkService
    private var timer: Timer?
    
    // MARK: State properties
    private var fromCurrency: String
    private var toCurrency: String
    private var amount: Double
    
    // MARK: Initialization
    init(networkService: NetworkService, fromCurrency: String = "EUR", toCurrency: String = "USD", amount: Double = 1) {
        self.networkService = networkService
        self.fromCurrency = fromCurrency
        self.toCurrency = toCurrency
        self.amount = amount
    }
    
    // MARK: Functions [Public]
    func setFromCurrency(_ currency: String) {
        fromCurrency = currency
        fetchConversion()
    }
    
    func setToCurrency(_ currency: String) {
        toCurrency = currency
        fetchConversion()
    }
    
    func setAmount(_ amount: String) {
        self.amount = Double(amount) ?? 0
        fetchConversion()
    }
    
    func startPeriodicUpdates() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { [weak self] _ in
            self?.fetchConversion()
        }
    }
    
    func stopPeriodicUpdates() {
        timer?.invalidate()
        timer = nil
    }
    
    func fetchConversion() {
        networkService.fetchConversion(fromAmount: amount,
                                       fromCurrency: fromCurrency,
                                       toCurrency: toCurrency) { [weak self] result in
            DispatchQueue.main.async { [weak self] in
                switch result {
                case .success(let conversion):
                    self?.delegate?.didUpdateConversion(amount: conversion.convertedAmount,
                                                        currency: conversion.currency)
                case .failure(let error):
                    self?.delegate?.didFailWithError(message: error.localizedDescription)
                }
            }
        }
    }
}