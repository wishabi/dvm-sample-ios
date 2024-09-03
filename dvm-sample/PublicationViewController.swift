// Copyright © 2024 Flipp. All rights reserved.

import dvm_sdk
import OSLog
import UIKit

class PublicationViewController: UIViewController {
  static let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier!,
    category: String(describing: PublicationViewController.self))

  var renderingMode: RenderMode?
  var publicationID: String?
  var merchantId: String?
  var storeCode: String?
  lazy var spinner = UIActivityIndicatorView()

  private var rendererView: DVMRendererView?

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Publication"
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
    spinner.startAnimating()

    guard let publicationID,
          let renderingMode,
          let merchantId,
          let storeCode else {
      spinner.stopAnimating()
      return
    }

    if let rendererView = try? DVMSDK.createRenderingView(
      publicationId: publicationID,
      merchantId: merchantId,
      storeCode: storeCode,
      renderMode: renderingMode,
      shouldPersistWebsiteDataToDisk: false
    ) {
      rendererView.rendererDelegate = self
      rendererView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(rendererView)
      self.rendererView = rendererView
      setupConstraints()
    }
    
    spinner.stopAnimating()
  }

  private func setupConstraints() {
    rendererView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
    rendererView?.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    rendererView?.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    rendererView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
  }

  override func viewDidAppear(_ animated: Bool) {
  }

  func pushDetailsController(for offer: Offer) {
    let detailsController = OfferDetailsViewHostController(offer: offer)
    self.present(
      UINavigationController(rootViewController: detailsController),
      animated: true)
  }
}

extension PublicationViewController: DVMRendererDelegate {
  func didTap(result: Result<dvm_sdk.Offer, dvm_sdk.DVMSDKError>) {
    switch result {
    case .success(let offer):
      self.pushDetailsController(for: offer)
    case .failure(let error):
      Self.logger.error("Error tapping on offer: \(error.localizedDescription)")
    }
  }

  func didFinishLoad() {
    Self.logger.debug("Did finish load")
  }

  func didFailToLoad(error: Error) {
    Self.logger.error("Failed to load publication: \(error.localizedDescription)")
  }
}
