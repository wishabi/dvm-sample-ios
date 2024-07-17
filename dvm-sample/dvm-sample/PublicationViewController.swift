// Copyright © 2024 Flipp. All rights reserved.

import dvm_sdk
import UIKit

class PublicationViewController: UIViewController {
  var renderingMode: RenderMode?
  var publicationID: String?

  private var rendererView: DVMRendererView?

  override func viewDidLoad() {
    super.viewDidLoad()
    guard let publicationID, let renderingMode else { return }
    let rendererView = DVMRendererView(
      viewController: self,
      publicationID: publicationID,
      renderMode: renderingMode
    )
    rendererView.rendererDelegate = self
    rendererView.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(rendererView)
    self.rendererView = rendererView
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
}

extension PublicationViewController: DVMRendererDelegate {
  func didTap(item: String) {

  }

  func didFinishLoad() {

  }

  func didFailToLoad(error: Error) {
    //inform error or implement retry logic.
  }
}
