//
//  Currency.swift
//  CurrencyConverter
//
//  Created by Migovich on 15.12.2024.
//

import Foundation

enum Currency: String, Codable, CaseIterable {
    case usd
    case eur
    case jpy
    case gbp
    case aud
    case cad
    
    var description: String {
        rawValue.uppercased()
    }
    
    var networkKey: String {
        rawValue.uppercased()
    }
}
