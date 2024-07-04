//
//  ExchangeRatesCollectionViewCell.swift
//  CurrencyConverter
//
//  Created by Vikas Salian on 14/05/23.
//

import UIKit

final class ExchangeRatesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var currencyRateStackView: UIStackView! {
        didSet {
            currencyRateStackView.layer.borderWidth = 1
            currencyRateStackView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        }
    }
    @IBOutlet weak var currencyNameLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!

    override func prepareForReuse() {
        rateLabel.text =  nil
        currencyNameLabel.text = nil
    }

    func configure(withCurrency currency: String, rate: Double) {
        currencyNameLabel.text = currency
        rateLabel.text = "\(rate)"
    }
}
