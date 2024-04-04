//
//  ExchangeRateViewModelTests.swift
//  CurrencyConverterTests
//
//  Created by Vikas Salian on 14/05/23.
//

import Foundation
import XCTest
@testable import CurrencyConverter

// Mock implementation of NetworkManaging protocol for testing
final class MockExchangeRateRepository: ExchangeRateRepositoryProtocol {

    var mockResponse: NetworkResult<Any> = .failure(NetworkError.invalidURL)

    func fetchExchangeRates(amount: Double, completion: @escaping (NetworkResult<ExchangeRates>) -> Void) {
        switch mockResponse {
        case .success(let response):
            guard let response = response as? ExchangeRates else {
                completion(.failure(NetworkError.decodingError))
                return
            }
            completion(.success(response))
        case .failure(let error):
            completion(.failure(error))
        }
    }

    func fetchAvailableCurrency(completion: @escaping (NetworkResult<[String: String]>) -> Void) {
        switch mockResponse {
        case .success(let response):
            guard let response = response as? [String: String] else {
                completion(.failure(NetworkError.decodingError))
                return
            }
            completion(.success(response))
        case .failure(let error):
            completion(.failure(error))
        }
    }
}

class ExchangeRateViewModelTests: XCTestCase {

    var sut: ExchangeRateViewModel!
    var repository: MockExchangeRateRepository!

    override func setUpWithError() throws {
        try super.setUpWithError()
        repository = MockExchangeRateRepository()
        sut = ExchangeRateViewModel(repository: repository)
    }

    override func tearDownWithError() throws {
        sut = nil
        repository = nil
        try super.tearDownWithError()
    }

    func testFetchAvailableCurrencySuccess() {
        // Given
        let expectedCurrencies = ["EUR", "JPY", "USD"]
        let currenciesDict = ["EUR": "Euro", "JPY": "Japanese Yen", "USD": "United States Dollar"]
        repository.mockResponse = .success(currenciesDict)

        // When
        sut.fetchAvailableCurrency()

        // Then
        XCTAssertEqual(sut.currencies.value, expectedCurrencies)
    }

    func testFetchAvailableCurrencyFailure() {
        // Given
        repository.mockResponse = .failure(NetworkError.invalidURL)

        // When
        sut.fetchAvailableCurrency()

        // Then
        XCTAssertEqual(sut.currencies.value, [])
    }

    func testFetchExchangeRatesSuccess() {
        // Given
        let expectedRates = [("EUR", 100.0), ("JPY", 13512.5), ("USD", 125.0)]
        let exchangeRates = ExchangeRates(rates: ["EUR": 0.8, "JPY": 108.1, "USD": 1.0])
        repository.mockResponse = .success(exchangeRates)

        // When
        sut.baseCurrency = "EUR"
        sut.fetchExchangeRates(amount: 100)

        // Then
        XCTAssertEqual(sut.sortedConvertedCurrencyRates.value.count, expectedRates.count)
        for (index, expectedRate) in expectedRates.enumerated() {
            XCTAssertEqual(sut.sortedConvertedCurrencyRates.value[index].key, expectedRate.0)
            XCTAssertEqual(sut.sortedConvertedCurrencyRates.value[index].value, expectedRate.1)
        }
    }

    func testFetchExchangeRatesFailure() {
        // Given
        repository.mockResponse = .failure(NetworkError.decodingError)

        // When
        sut.fetchExchangeRates(amount: 100)

        // Then
        XCTAssertEqual(sut.sortedConvertedCurrencyRates.value.count, 0)
    }

}
