//
//  ExchangeRateRepository.swift
//  CurrencyConverter
//
//  Created by Vikas Salian on 15/05/23.
//

import Foundation

protocol ExchangeRateRepositoryProtocol {
    func fetchExchangeRates(amount: Double, completion:  @escaping (NetworkResult<ExchangeRates>) -> Void)
    func fetchAvailableCurrency(completion: @escaping (NetworkResult<[String: String]>) -> Void)
}

final class ExchangeRateRepository: ExchangeRateRepositoryProtocol {
    private let apiService: ExchangeRateApiServiceProtocol

    /// Initializes a new instance of the `ExchangeRateRepository` class with the specified `ExchangeRateApiServiceProtocol` instance.
    /// - Parameter apiService: An instance of `ExchangeRateApiServiceProtocol`.
    init(apiService: ExchangeRateApiServiceProtocol = ExchangeRateApiService()) {
        self.apiService = apiService
    }

    /// Fetches the currency exchange rates based on the given amount.
    /// - Parameters:
    ///   - amount: A `Double` value representing the amount to exchange.
    ///   - completion: A completion block that will be called when the API call finishes, returning a `NetworkResult` object containing either the fetched `ExchangeRates` or an error.
    func fetchExchangeRates(amount: Double, completion: @escaping (NetworkResult<ExchangeRates>) -> Void) {
        apiService.fetchExchangeRates(amount: amount, completion: completion)
    }

    /// Fetches the available currencies.
    /// - Parameter completion: A completion block that will be called when the API call finishes, returning a `NetworkResult` object containing either the fetched `[String: String]` or an error.
    func fetchAvailableCurrency(completion: @escaping (NetworkResult<[String: String]>) -> Void) {
        apiService.fetchAvailableCurrency(completion: completion)
    }

}
