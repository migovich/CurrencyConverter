//
//  NetworkService.swift
//  CurrencyConverter
//
//  Created by Migovich on 14.12.2024.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case decodingError(Error)
}

class NetworkService {
    private let session: URLSession
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func fetchConversion(fromAmount: Double, fromCurrency: String, toCurrency: String, completion: @escaping (Result<ConversionResponse, NetworkError>) -> Void) {
        let urlString = "http://api.evp.lt/currency/commercial/exchange/\(fromAmount)-\(fromCurrency)/\(toCurrency)/latest"
        guard let url = URL(string: urlString) else {
            completion(.failure(.invalidURL))
            return
        }
        let task = session.dataTask(with: url) { data, response, error in
            if let err = error {
                completion(.failure(.requestFailed(err)))
                return
            }
            guard let data = data,
                    let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                completion(.failure(.invalidResponse))
                return
            }
            do {
                let result = try JSONDecoder().decode(ConversionResponse.self, from: data)
                completion(.success(result))
            } catch let decodeError {
                completion(.failure(.decodingError(decodeError)))
            }
        }
        task.resume()
    }
}
