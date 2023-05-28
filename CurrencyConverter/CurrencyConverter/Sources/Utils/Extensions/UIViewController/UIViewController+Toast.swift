//
//  UIViewController+Toast.swift
//  CurrencyConverter
//
//  Created by Vikas Salian on 14/05/23.
//

import UIKit

extension UIViewController {
    func showToast(message: String) {
        let toastView = ToastView(message: message)
        view.addSubview(toastView)
        toastView.translatesAutoresizingMaskIntoConstraints = false
        toastView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        toastView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50).isActive = true
        toastView.alpha = 0.0
        toastView.show()
    }
}
