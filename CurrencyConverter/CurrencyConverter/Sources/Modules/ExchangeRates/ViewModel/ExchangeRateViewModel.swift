//
//  ExchangeRateViewModel.swift
//  CurrencyConverter
//
//  Created by Vikas Salian on 14/05/23.
//

import Foundation

protocol ExchangeRateViewModelProtocol {
    var currencies: Observable<[String]> { get }
    var sortedConvertedCurrencyRates: Observable<[(key: String, value: Double)]> { get }
    var baseCurrency: String { get set }
    var loadingState: Observable<Bool> {get set}
    func fetchExchangeRates(amount: Double)
    func fetchAvailableCurrency()
}

final class ExchangeRateViewModel: ExchangeRateViewModelProtocol {

    /// A list of available sorted currencies.
    private(set) var currencies = Observable(element: [String]())

    /// The list of sorted currency rates after conversion.
    private(set) var sortedConvertedCurrencyRates = Observable(element: [(key: String, value: Double)]())

    /// The base currency used for conversion.
    var baseCurrency: String = "USD"

    /// The repository object responsible for communicating with the exchange rate API.
    private let repository: ExchangeRateRepositoryProtocol

    var loadingState: Observable<Bool> = Observable(element: false)

    /// Initializes the view model with a repository object.
    /// - Parameter repository: The repository object responsible for communicating with the exchange rate API.
    init(repository: ExchangeRateRepositoryProtocol = ExchangeRateRepository()) {
        self.repository = repository
    }

    /// Fetches the exchange rates for the given amount.
    /// - Parameter amount: The amount to convert.
    func fetchExchangeRates(amount: Double) {
        loadingState.value = true
        repository.fetchExchangeRates(amount: amount) { [weak self] (result: NetworkResult<ExchangeRates>) in
            guard let self else {
                return
            }
            switch result {
            case .success(let exchangeRates):
                let convertedCurrencyRates = exchangeRates.convertedAmount(for: amount, baseCurrency: self.baseCurrency)
                self.sortedConvertedCurrencyRates.value = convertedCurrencyRates.sorted(by: <)
            case .failure(let error):
                print("Error fetching exchange rates \(error.localizedDescription)")
            }
            self.loadingState.value = false
        }
    }

    /// Fetches the available currencies.
    func fetchAvailableCurrency() {
        loadingState.value = true
        repository.fetchAvailableCurrency { (result: NetworkResult<[String: String]>) in
            switch result {
            case .success(let currenciesDict):
                var currencies = [ExchangeCurrency]()

                for (code, name) in currenciesDict {
                    let currency = ExchangeCurrency(code: code, name: name)
                    currencies.append(currency)
                }

                self.currencies.value = (currencies.map {$0.code}).sorted(by: <)
            case .failure(let error):
                print("Error fetching exchange rates \(error.localizedDescription)")
            }
            self.loadingState.value = false
        }
    }

   
}
