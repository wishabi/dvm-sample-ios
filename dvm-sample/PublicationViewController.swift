// Copyright © 2024 Flipp. All rights reserved.

import dvm_sdk
import UIKit

class PublicationViewController: UIViewController {
  var renderingMode: RenderMode?
  var publicationID: String?
  var merchantId: String?
  var storeCode: String?

  private var rendererView: DVMRendererView?

  override func viewDidLoad() {
    super.viewDidLoad()
    guard let publicationID, let renderingMode, let merchantId, let storeCode else { return }
    if let rendererView = try? DVMSDK.createRenderingView(
      publicationId: publicationID,
      merchantId: merchantId,
      storeCode: storeCode,
      renderMode: renderingMode
    ) {
      rendererView.rendererDelegate = self
      rendererView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(rendererView)
      self.rendererView = rendererView
    }
    setupConstraints()
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
    let detailsController = ItemDetailsViewController(offer: offer)
    self.present(detailsController, animated: true)
  }
}

extension PublicationViewController: DVMRendererDelegate {
  func didTap(item: Offer) {
    self.pushDetailsController(for: item)
  }

  func didFinishLoad() {

  }

  func didFailToLoad(error: Error) {
    //inform error or implement retry logic.
  }
}
