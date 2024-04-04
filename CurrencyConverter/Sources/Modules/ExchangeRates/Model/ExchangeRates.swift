//
//  ExchangeRates.swift
//  CurrencyConverter
//
//  Created by Vikas Salian on 13/05/23.
//

import Foundation

protocol ExchangeRatesProtocol {
    var rates: [String: Double]? { get }

    func convertedAmount(for amount: Double, baseCurrency: String) -> [String: Double]
}

struct ExchangeRates: Codable, ExchangeRatesProtocol {
    let rates: [String: Double]?

    /// Calculates the converted amount for the given amount in the base currency.
    /// - Parameter amount: The amount to convert.
    /// - Returns: A dictionary with the converted amounts for each currency.
    func convertedAmount(for amount: Double, baseCurrency: String) -> [String: Double] {
        var convertedAmounts = [String: Double]()

        // we get baseCurrency worth of other currency we first have to get baseCurrency equivalent of USD which 1 divided by baseCurrency because openexchangerates API is pegged against USD
        let baseCurrencyValue = (rates?[baseCurrency] ?? defaultCurrencyRates?[baseCurrency] ?? 1.0)
        let baseCurrencyValuePeggedToUSD = 1.0 / baseCurrencyValue

        // Loop through each currency and its exchange rates.
        for (currency, rate) in (rates ?? [:]) {
            // Calculate the converted amount for the given currency.
            // We multiple amount & the rate compared to usd & baseCurrencyValue compared to USD
            let convertedAmount = amount * rate * baseCurrencyValuePeggedToUSD

            // Add the converted amount to the dictionary.
            convertedAmounts[currency] = baseCurrency == currency ? amount :  convertedAmount
        }

        // Return the dictionary of converted amounts.
        return convertedAmounts
    }

    // A dictionary of default currency rates loaded from a JSON file
    var defaultCurrencyRates: [String: Double]? {
        // Get the default currency rates from a JSON file
        getDefaultCurrencyRates()
    }

    ///  Reads the default currency rates from a JSON file and returns them as a dictionary
    /// - Returns: Default Dictionary of CurrencyRates
    private func getDefaultCurrencyRates() -> [String: Double]? {
        // Get the path to the JSON file in the app's main bundle
        if let path = Bundle.main.path(forResource: "currencyRates", ofType: "json") {
            do {
                // Read the contents of the JSON file into a Data object
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                // Try to parse the JSON data into a dictionary
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Double] {
                    // Return the parsed dictionary
                    return json
                }
            } catch {
                // If an error occurs, log it and return nil
                print("Error reading JSON file: \(error)")
                return nil
            }
        }
        // If the JSON file cannot be read, return nil
        return nil
    }
}
