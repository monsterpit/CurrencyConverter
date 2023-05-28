//
//  ExchangeRateViewController.swift
//  CurrencyConverter
//
//  Created by Vikas Salian on 13/05/23.
//

import UIKit

final class ExchangeRateViewController: UIViewController {

    @IBOutlet weak var amountTextField: UITextField!
    @IBOutlet weak var currencySelectorView: DropdownView!
    @IBOutlet weak var exchangeRatesCollectionView: UICollectionView!{
        didSet{
            exchangeRatesCollectionView.accessibilityIdentifier = "exchangeRatesCollectionView"
        }
    }

    let activityIndicator = UIActivityIndicatorView(style: .large)
    var viewModel: ExchangeRateViewModelProtocol = ExchangeRateViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAmountTextField()
        setupCurrenciesDropDownView()
        setupExchangeRatesGrid()
        setupLoader()
    }
}

// Setup DropDownView
extension ExchangeRateViewController {
    /// Sets up the currencies dropdown view and configures it with the available currencies obtained from the view model. Also, observes changes in the available currencies and converted currency rates in the view model and updates the currencySelectorView and exchangeRatesCollectionView respectively. Finally, sets the base currency in the view model when a currency is selected in the dropdown view.
    private func setupCurrenciesDropDownView() {
        viewModel.fetchAvailableCurrency()
        viewModel.currencies.observe { [weak self] exchangeCurrencies in
            self?.currencySelectorView.dropdownItems = exchangeCurrencies
        }
        currencySelectorView.didSelect { [weak self] (selectedCurrencyCode, _) in
            self?.viewModel.baseCurrency = selectedCurrencyCode

            guard let amountText = self?.amountTextField.text, let amount = Double(amountText) else {
                return
            }
            self?.viewModel.fetchExchangeRates(amount: amount)
        }
        viewModel.sortedConvertedCurrencyRates.observe { _ in
            DispatchQueue.main.async { [weak self] in
                self?.exchangeRatesCollectionView.reloadData()
            }
        }
    }
}

// Loader Setup
extension ExchangeRateViewController {

    private func setupLoader() {
        // Add the activity indicator to the view
        activityIndicator.center = view.center
        view.addSubview(activityIndicator)

        viewModel.loadingState.observe {  isLoading in
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                if isLoading {
                    // Show loader
                    self.showLoader()
                } else {
                    // Hide loader
                    self.hideLoader()
                }
            }
        }
    }

    private func showLoader() {
        // Start animating the activity indicator
        activityIndicator.startAnimating()
    }

    private func hideLoader() {
        // Start animating the activity indicator
        activityIndicator.stopAnimating()

    }

}

extension ExchangeRateViewController: UITextFieldDelegate {

    private func setupAmountTextField() {
        // Create a UIToolbar with a "Done" button
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        toolbar.items = [UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneButton]

        // Set the toolbar as the input accessory view of the text field
        amountTextField.inputAccessoryView = toolbar
    }

    // Handle the "Done" button tap
    @objc func doneButtonTapped() {
        amountTextField.resignFirstResponder()
        dismissKeyboardAndFetchExchangeRates()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        dismissKeyboardAndFetchExchangeRates()
        return true
    }

    private func dismissKeyboardAndFetchExchangeRates() {
        // Dismiss the keyboard
        amountTextField.resignFirstResponder()

        guard let amountText = amountTextField.text, let amount = Double(amountText) else {
            showToast(message: "Please enter a valid amount")
            return
        }

        guard currencySelectorView.text != currencySelectorView.placeHolderText else {
            showToast(message: "Please select the currency")
            return
        }
        viewModel.fetchExchangeRates(amount: amount)
    }
}

extension ExchangeRateViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    /// This function sets up the ExchangeRatesCollectionView by configuring its flow layout, item size, interitem spacing and line spacing. It also registers the ExchangeRatesCollectionViewCell.
    private func setupExchangeRatesGrid() {
        // Configure the flow layout
        let flowLayout = UICollectionViewFlowLayout()
        let itemWidth = exchangeRatesCollectionView.bounds.width / 3.0
        flowLayout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0

        // Set the collection view layout
        exchangeRatesCollectionView.collectionViewLayout = flowLayout
        exchangeRatesCollectionView.register(UINib(nibName: ExchangeRatesCollectionViewCell.identifier, bundle: nil), forCellWithReuseIdentifier: ExchangeRatesCollectionViewCell.identifier)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.sortedConvertedCurrencyRates.value.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ExchangeRatesCollectionViewCell.identifier, for: indexPath) as! ExchangeRatesCollectionViewCell
        let currencyCode = viewModel.sortedConvertedCurrencyRates.value[indexPath.row].key
        let currencyRate = viewModel.sortedConvertedCurrencyRates.value[indexPath.row].value
        cell.configure(withCurrency: currencyCode, rate: currencyRate)
        return cell
    }
}
