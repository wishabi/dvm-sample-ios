//
//  OfferDetailsViewHostController.swift
//  dvm-sample
//
//  Created by William Chang on 2024-08-29.
//

import dvm_sdk
import Foundation
import SwiftUI

class OfferDetailsViewHostController: UIHostingController<OfferDetailsView> {
  init(offer: Offer) {
    super.init(rootView: OfferDetailsView(viewModel: OfferDetailsViewModel(from: offer)))
  }
  
  @MainActor required dynamic init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationItem.rightBarButtonItem = UIBarButtonItem(
      barButtonSystemItem: .done,
      target: self,
      action: #selector(doneButtonTapped))
  }

  @objc private func doneButtonTapped() {
    dismiss(animated: true)
  }
}
