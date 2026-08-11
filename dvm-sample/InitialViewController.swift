// Copyright © 2024 Flipp. All rights reserved.

import UIKit

/// Options collected on the initial screen that are forwarded to the renderer to
/// showcase the SDK's rendering configuration (location vs merchant, zoom, linked offer).
struct RenderOptions {
  var disableZoom: Bool
  var linkedOfferId: String?
  var postalCode: String?
  var countryCode: String?
}

class InitialViewController: UIViewController, UITextFieldDelegate {

  private let merchantTextField = InitialViewController.makeField(placeholder: "Enter merchant", text: "2018")
  private let storeCodeTextField = InitialViewController.makeField(placeholder: "Enter store code", text: "1174")
  private let postalCodeTextField = InitialViewController.makeField(placeholder: "Optional, e.g. M5V 2H1")
  private let countryCodeTextField = InitialViewController.makeField(placeholder: "Optional, e.g. CA")
  private let linkedOfferTextField = InitialViewController.makeField(placeholder: "Optional offer id to link")
  private let disableZoomSwitch = UISwitch()

  private let loadPublicationsButton: UIButton = {
    let button = UIButton(frame: .zero)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: .medium)
    button.setTitleColor(.default0, for: .normal)
    button.tintColor = .default0
    button.setTitle("Load Publications", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .primary3
    button.layer.cornerRadius = .extraExtraSmall
    button.contentEdgeInsets = UIEdgeInsets(top: 8, left: 12, bottom: 8, right: 12)
    return button
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .appBackground

    let stack = UIStackView(arrangedSubviews: [
      labeledRow("Merchant", merchantTextField),
      labeledRow("Store Code", storeCodeTextField),
      sectionLabel("Rendering options"),
      labeledRow("Postal Code (location render)", postalCodeTextField),
      labeledRow("Country Code (location render)", countryCodeTextField),
      labeledRow("Linked Offer ID", linkedOfferTextField),
      switchRow("Disable Zoom", disableZoomSwitch),
      loadPublicationsButton,
    ])
    stack.axis = .vertical
    stack.spacing = 16
    stack.alignment = .fill
    stack.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(stack)

    NSLayoutConstraint.activate([
      stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
    ])

    [merchantTextField, storeCodeTextField, postalCodeTextField,
     countryCodeTextField, linkedOfferTextField].forEach { $0.delegate = self }

    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
    view.addGestureRecognizer(tapGesture)
    loadPublicationsButton.addTarget(self, action: #selector(loadPublicationsButtonTapped), for: .touchUpInside)
  }

  // MARK: - View builders

  private static func makeField(placeholder: String, text: String? = nil) -> UITextField {
    let textField = BorderedTextField()
    textField.placeholder = placeholder
    textField.text = text
    textField.autocapitalizationType = .none
    textField.autocorrectionType = .no
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }

  private func sectionLabel(_ text: String) -> UILabel {
    let label = UILabel()
    label.text = text
    label.textColor = .default5
    label.font = UIFont.boldSystemFont(ofSize: .medium)
    return label
  }

  private func labeledRow(_ title: String, _ field: UITextField) -> UIStackView {
    let label = UILabel()
    label.text = title
    label.textColor = .default5
    let row = UIStackView(arrangedSubviews: [label, field])
    row.axis = .vertical
    row.spacing = 8
    return row
  }

  private func switchRow(_ title: String, _ control: UISwitch) -> UIStackView {
    let label = UILabel()
    label.text = title
    label.textColor = .default5
    let spacer = UIView()
    spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)
    let row = UIStackView(arrangedSubviews: [label, spacer, control])
    row.axis = .horizontal
    row.spacing = 8
    row.alignment = .center
    return row
  }

  // MARK: - Actions

  @objc func dismissKeyboard() {
    view.endEditing(true)
  }

  func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    textField.resignFirstResponder()
    return true
  }

  private func nonEmpty(_ textField: UITextField) -> String? {
    guard let text = textField.text?.trimmingCharacters(in: .whitespacesAndNewlines),
          !text.isEmpty else { return nil }
    return text
  }

  @objc func loadPublicationsButtonTapped() {
    guard let merchant = nonEmpty(merchantTextField),
          let storeCode = nonEmpty(storeCodeTextField) else {
      let alert = UIAlertController(title: "Error", message: "Please fill in merchant and store code", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
      present(alert, animated: true, completion: nil)
      return
    }

    let publicationsViewController = PublicationsViewController()
    publicationsViewController.merchantID = merchant
    publicationsViewController.storeCode = storeCode
    publicationsViewController.renderOptions = RenderOptions(
      disableZoom: disableZoomSwitch.isOn,
      linkedOfferId: nonEmpty(linkedOfferTextField),
      postalCode: nonEmpty(postalCodeTextField),
      countryCode: nonEmpty(countryCodeTextField))
    navigationController?.navigationBar.barTintColor = .default0
    navigationController?.pushViewController(publicationsViewController, animated: true)
  }
}
