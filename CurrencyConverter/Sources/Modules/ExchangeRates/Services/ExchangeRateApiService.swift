//
//  ExchangeRateApiService.swift
//  CurrencyConverter
//
//  Created by Vikas Salian on 15/05/23.
//

import Foundation

protocol ExchangeRateApiServiceProtocol {
    func fetchExchangeRates(amount: Double, completion:  @escaping (NetworkResult<ExchangeRates>) -> Void)
    func fetchAvailableCurrency(completion: @escaping (NetworkResult<[String: String]>) -> Void)
}

final class ExchangeRateApiService: ExchangeRateApiServiceProtocol {

    /// The object that handles the network requests and responses.
    private let networkManager: NetworkManaging

    /// The app ID required for the server API.
    private var appID: String {
        return "3c744336870b48ab8459d3d4156fda83"
    }

    /// The key for the `appID` query parameter.
    private let appIDKey = "app_id"

    /// Initializes a new instance of the `ExchangeRateApiService` class.
    /// - Parameter networkManager: networkManager: The object that handles the network requests and responses. By default, this is set to a new instance of the `NetworkManager` class.
    init(networkManager: NetworkManaging = NetworkManager()) {
        self.networkManager = networkManager
    }

    /// Fetches exchange rates from the remote server.
    /// - Parameters:
    ///   - amount: The amount to use as the base currency value for the exchange rate calculation.
    ///   - completion: The closure to execute when the network request is completed. The closure takes a single parameter that indicates the result of the request.
    func fetchExchangeRates(amount: Double, completion: @escaping (NetworkResult<ExchangeRates>) -> Void) {
        networkManager.request(ExchangeRateEndPoint(queryParameters: [appIDKey: appID]), completion: completion)
    }

    /// Fetches available currencies from the remote server.
    /// - Parameter completion: The closure to execute when the network request is completed. The closure takes a single parameter that indicates the result of the request.
    func fetchAvailableCurrency(completion:  @escaping (NetworkResult<[String: String]>) -> Void) {
        networkManager.request(CurrencyListingEndPoint(queryParameters: [appIDKey: appID]), completion: completion)
    }
}
