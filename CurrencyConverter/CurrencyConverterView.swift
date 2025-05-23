//
//  CurrencyConverterView.swift
//  CurrencyConverter
//
//  Created by Migovich on 14.12.2024.
//

import UIKit

protocol CurrencyConverterViewDelegate: AnyObject {
    func didChangeFromCurrency(_ currency: Currency)
    func didChangeToCurrency(_ currency: Currency)
    func didChangeAmount(_ amount: String)
}

class CurrencyConverterView: UIView {
    weak var delegate: CurrencyConverterViewDelegate?
    
    private let fromCurrencyPicker = UIPickerView()
    private let toCurrencyPicker = UIPickerView()
    private let amountTextField = UITextField()
    private let resultLabel = UILabel()
    private let lastUpdatedLabel = UILabel()
    private let loadingIndicator = UIActivityIndicatorView(style: .medium)
    
    private let currencies: [Currency] = Currency.allCases
    private var selectedFromCurrency: Currency = .eur
    private var selectedToCurrency: Currency = .usd
    
    var isLoading: Bool = false {
        didSet {
            isLoading ? loadingIndicator.startAnimating() : loadingIndicator.stopAnimating()
        }
    }
    
    // MARK: Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Configuration
    private func configureViews() {
        backgroundColor = .systemBackground
        fromCurrencyPicker.dataSource = self
        fromCurrencyPicker.delegate = self
        toCurrencyPicker.dataSource = self
        toCurrencyPicker.delegate = self
        
        amountTextField.borderStyle = .roundedRect
        amountTextField.placeholder = "Enter amount"
        amountTextField.keyboardType = .decimalPad
        amountTextField.addTarget(self, action: #selector(amountChanged), for: .editingChanged)
        
        resultLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        resultLabel.textAlignment = .center
        
        loadingIndicator.hidesWhenStopped = true
        
        let pickerStack = UIStackView(arrangedSubviews: [fromCurrencyPicker, toCurrencyPicker])
        pickerStack.axis = .horizontal
        pickerStack.distribution = .fillEqually
        
        let mainStack = UIStackView(arrangedSubviews: [pickerStack, amountTextField, resultLabel, lastUpdatedLabel, loadingIndicator])
        mainStack.axis = .vertical
        mainStack.spacing = 20
        mainStack.alignment = .center
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16),
            mainStack.centerXAnchor.constraint(equalTo: centerXAnchor),
            mainStack.widthAnchor.constraint(lessThanOrEqualTo: widthAnchor, multiplier: 0.8),
            amountTextField.widthAnchor.constraint(equalTo: mainStack.widthAnchor),
        ])
        
        selectRow(in: fromCurrencyPicker, for: selectedFromCurrency, animated: false)
        selectRow(in: toCurrencyPicker, for: selectedToCurrency, animated: false)
    }
    
    // MARK: Public Methods
    func setConvertedAmount(_ text: String) {
        resultLabel.text = text
    }
    
    func setLastUpdated(_ text: String) {
        lastUpdatedLabel.text = "Last updated: \(text)"
    }
    
    // MARK: Actions
    @objc private func amountChanged() {
        delegate?.didChangeAmount(amountTextField.text ?? "")
    }
    
    // MARK: Helpers
    private func selectRow(in pickerView: UIPickerView, for currency: Currency, animated: Bool = true) {
        guard let index = currencies.firstIndex(of: currency) else {
            print("⚠️ No index found for \(currency)")
            return
        }
        pickerView.selectRow(index, inComponent: 0, animated: animated)
    }
}

// MARK: - UIPickerView DataSource/Delegate
extension CurrencyConverterView: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row].description
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == fromCurrencyPicker {
            guard currencies[row] != selectedToCurrency else {
                selectRow(in: fromCurrencyPicker, for: selectedFromCurrency)
                return
            }
            selectedFromCurrency = currencies[row]
            delegate?.didChangeFromCurrency(selectedFromCurrency)
        } else if pickerView == toCurrencyPicker {
            guard currencies[row] != selectedFromCurrency else {
                selectRow(in: toCurrencyPicker, for: selectedToCurrency)
                return
            }
            selectedToCurrency = currencies[row]
            delegate?.didChangeToCurrency(selectedToCurrency)
        }
    }
}
