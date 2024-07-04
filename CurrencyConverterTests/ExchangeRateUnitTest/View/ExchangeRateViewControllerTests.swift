//
//  ExchangeRateViewControllerTests.swift
//  CurrencyConverterTests
//
//  Created by Vikas Salian on 14/05/23.
//

import XCTest
@testable import CurrencyConverter
final class ExchangeRateViewControllerTests: XCTestCase {

    var sut: ExchangeRateViewController!

    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "ExchangeRateViewController") as? ExchangeRateViewController
        sut.loadViewIfNeeded()
    }

    override func tearDownWithError() throws {
        sut = nil
        try super.tearDownWithError()
    }

    func testExchangeRatesCollectionViewDataSource() throws {
        // Given
        let collectionView = try XCTUnwrap(sut.exchangeRatesCollectionView)
        let mockViewModel = MockExchangeRateViewModel()
        let mockRates: [(key: String, value: Double)] = [("EUR", 0.85), ("GBP", 0.73), ("JPY", 109.26)]
        mockViewModel.sortedConvertedCurrencyRates.value = mockRates
        sut.viewModel = mockViewModel

        // When
        let dataSource = sut.collectionView(collectionView, numberOfItemsInSection: 0)

        // Then
        XCTAssertEqual(dataSource, mockRates.count)
    }

    func testAmountTextFieldShouldReturn() throws {
        // Given
        let mockViewModel = MockExchangeRateViewModel()
        sut.viewModel = mockViewModel

        // When
        let mockCurrencies: [String] = [ "EUR", "JPY", "USD"]
        let currenciesFetchExpectation = self.expectation(description: "currencies fetched")
        currenciesFetchExpectation.assertForOverFulfill = false
        mockViewModel.currencies.observe { _ in
            currenciesFetchExpectation.fulfill()
        }
        mockViewModel.currencies.value = mockCurrencies

        let mockRates: [(key: String, value: Double)] = [("EUR", 0.85), ("GBP", 0.73), ("JPY", 109.26)]
        let exchangeRateFetchExpectation = self.expectation(description: "exchange rates fetched")
        exchangeRateFetchExpectation.assertForOverFulfill = false
        mockViewModel.sortedConvertedCurrencyRates.observe { _ in
            exchangeRateFetchExpectation.fulfill()
        }
        mockViewModel.sortedConvertedCurrencyRates.value = mockRates

        // Then
        // Checking if outlets is available
        _ = try XCTUnwrap(sut.amountTextField)
        _ = try XCTUnwrap(sut.currencySelectorView)
        _ = try XCTUnwrap(sut.exchangeRatesCollectionView)
        // Setting expectation timeout to 1
        waitForExpectations(timeout: 1, handler: nil)

    }
}

class MockExchangeRateViewModel: ExchangeRateViewModelProtocol {
    var loadingState: CurrencyConverter.Observable<Bool> = Observable(element: false)

    var baseCurrency: String = "USD"

    var currencies: Observable<[String]> = Observable(element: [ "EUR", "JPY", "USD"])

    var sortedConvertedCurrencyRates: Observable<[(key: String, value: Double)]> = Observable(element: [("EUR", 0.82), ("JPY", 109.97), ("USD", 1.0)])

    func fetchExchangeRates(amount: Double) {
        // Return a fixed set of values for testing
        sortedConvertedCurrencyRates.value = [("EUR", 0.82), ("JPY", 109.97), ("USD", 1.0)]
    }

    func fetchAvailableCurrency() {
        // Return a fixed set of values for testing
        currencies.value = ["EUR", "JPY", "USD"]
    }

}
