//
//  ToastMessage.swift
//  CurrencyConverter
//
//  Created by Vikas Salian on 14/05/23.
//

import UIKit

class ToastView: UIView {

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .white
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let padding: CGFloat = 16.0

    init(message: String) {
        super.init(frame: .zero)
        backgroundColor = .black
        layer.cornerRadius = 10
        addSubview(messageLabel)
        messageLabel.text = message

        messageLabel.topAnchor.constraint(equalTo: topAnchor, constant: padding).isActive = true
        messageLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: padding).isActive = true
        messageLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -padding).isActive = true
        messageLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -padding).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func show() {
        alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, options: [.curveEaseInOut], animations: {
            self.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.5, delay: 1.0, animations: {
                self.alpha = 0
            }, completion: { _ in
                self.removeFromSuperview()
            })
        }
    }
}
