//
//  DropdownView.swift
//  CurrencyConverter
//
//  Created by Vikas Salian on 14/05/23.
//

import UIKit

final class DropdownView: UITextField {

    // Create a table view to display the dropdown items
    private let tableView = UITableView()
    private let backGroundView = UIView()

    // Add the arrow image view
    private let paddedImageView = PaddedImageView()

    // Array of items to be shown in the dropdown
    var dropdownItems: [String] = []

    private var tableViewHeightConstraint: NSLayoutConstraint?
    private var dropDownHeight: CGFloat = 200

    private var didSelectionCompletion: ((String, Int) -> Void)?

    var placeHolderText = "Please select a currency"

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }

    private func setup() {
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(toggleDropDown)))
        backGroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissDropDown)))

        delegate = self
        text = placeHolderText

        paddedImageView.imageView.image = UIImage(systemName: "chevron.down")?.withRenderingMode(.alwaysTemplate)
        paddedImageView.imageView.tintColor = .black
        rightView = paddedImageView
        rightViewMode = .always

        // Create a padding view with the desired width
        let leftPaddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: frame.size.height))
        // Set the padding view as the right view of the text field
        leftView =  leftPaddingView
        leftViewMode = .always

        // Add the table view to the view hierarchy and constrain it to fill the entire view
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.register(DropdownCell.self, forCellReuseIdentifier: DropdownCell.identifier)
        tableView.layer.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1).cgColor
        tableView.layer.borderWidth = 1
        tableView.alpha = 0
        tableView.accessibilityIdentifier = "DropdownTableView"

        // Set the table view's delegate and data source to this view
        tableView.delegate = self
        tableView.dataSource = self
    }

    @objc func toggleDropDown() {
        tableView.removeConstraints(tableView.constraints)
        tableView.removeFromSuperview()
        backGroundView.removeConstraints(backGroundView.constraints)
        backGroundView.removeFromSuperview()

        superview?.addSubview(tableView)
        tableView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        tableView.topAnchor.constraint(equalTo: bottomAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        tableViewHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: tableView.alpha != 0 ? dropDownHeight : 0)
        tableViewHeightConstraint?.isActive = true
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let self else { return }
            if self.tableView.alpha != 0 {
                self.tableViewHeightConstraint?.constant = 0
                self.tableView.alpha = 0
                self.paddedImageView.transform = CGAffineTransform.identity
            } else {
                self.tableViewHeightConstraint?.constant =  self.dropDownHeight
                self.tableView.alpha = 1
                self.paddedImageView.transform = CGAffineTransform(rotationAngle: .pi)
            }
            self.layoutIfNeeded()
        }
    }

    @objc func dismissDropDown() {
        if tableView.alpha == 1 {
            toggleDropDown()
        }
    }

    func didSelect(completion: ((_ selectedString: String, _ index: Int) -> Void)?) {
        didSelectionCompletion = completion
    }
}

extension DropdownView: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
}

extension DropdownView: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of items in the dropdown
        return dropdownItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Dequeue and configure a table view cell to display a dropdown item
        let cell = tableView.dequeueReusableCell(withIdentifier: DropdownCell.identifier, for: indexPath) as! DropdownCell
        cell.configure(withTitle: dropdownItems[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        text = dropdownItems[indexPath.row]
        toggleDropDown()
        didSelectionCompletion?(dropdownItems[indexPath.row], indexPath.row)
    }

}
