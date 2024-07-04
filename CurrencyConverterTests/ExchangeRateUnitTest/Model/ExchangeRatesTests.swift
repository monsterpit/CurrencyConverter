//
//  ExchangeRatesTests.swift
//  CurrencyConverterTests
//
//  Created by Vikas Salian on 14/05/23.
//

import XCTest
@testable import CurrencyConverter
final class ExchangeRatesTests: XCTestCase {

    func testConvertedAmounts() {
         let rates = ["USD": 1.0, "EUR": 0.82, "GBP": 0.71]
         let exchangeRates = ExchangeRates(rates: rates)
         let convertedAmounts = exchangeRates.convertedAmount(for: 100, baseCurrency: "USD")
         XCTAssertEqual(convertedAmounts.count, 3, "There should be 3 converted amounts.")
         XCTAssertEqual(convertedAmounts["USD"], 100.0, "USD should equal the original amount.")
         XCTAssertEqual(convertedAmounts["EUR"], 82.0, "EUR should be converted correctly.")
         XCTAssertEqual(convertedAmounts["GBP"], 71.0, "GBP should be converted correctly.")
     }

     func testDefaultCurrencyRates() {
         let exchangeRates = ExchangeRates(rates: nil)
         let defaultRates = exchangeRates.defaultCurrencyRates
         XCTAssertEqual(defaultRates?.count, 170, "There should be 170 default currency rates.")
         XCTAssertEqual(defaultRates?["USD"], 1.0, "USD should be included in the default rates.")
         XCTAssertEqual(defaultRates?["EUR"], 0.914286, "EUR should be included in the default rates.")
         XCTAssertEqual(defaultRates?["GBP"], 0.8026, "GBP should be included in the default rates.")
     }

     func testDefaultCurrencyRatesWithMissingData() {
         let exchangeRates = ExchangeRates(rates: nil)
         let defaultRates = exchangeRates.defaultCurrencyRates
         XCTAssertEqual(defaultRates?.count, 170, "There should be 170 default currency rates.")
         XCTAssertEqual(defaultRates?["USD"], 1.0, "USD should be included in the default rates.")
         XCTAssertEqual(defaultRates?["EUR"], 0.914286, "EUR should be included in the default rates.")
         XCTAssertEqual(defaultRates?["GRP"], nil, "GBP should not be included in the default rates.")
     }

}
