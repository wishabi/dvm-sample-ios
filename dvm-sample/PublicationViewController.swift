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
  var renderOptions = RenderOptions(disableZoom: false, linkedOfferId: nil, postalCode: nil, countryCode: nil)
  lazy var spinner = UIActivityIndicatorView()

  private var rendererView: DVMRendererView?

  /// A native view pinned to the bottom that overlays the publication. Space for it is
  /// reserved via `DVMRendererView.bottomContentInset` so publication content can scroll
  /// clear of it — showcasing native content layered over the rendered publication.
  private let footerView = UIView()
  private let statusLabel = UILabel()
  private static let footerHeight: CGFloat = 44

  override func viewDidLoad() {
    super.viewDidLoad()

    title = "Publication"
    view.backgroundColor = .appBackground
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: spinner)
    spinner.startAnimating()

    guard let publicationID, let renderingMode else {
      spinner.stopAnimating()
      return
    }

    guard let publicationInfo = makePublicationInfo() else {
      spinner.stopAnimating()
      setStatus("Missing merchant/store or postal/country info")
      return
    }

    if let rendererView = try? DVMSDK.createRenderingView(
      publicationId: publicationID,
      publicationInfo: publicationInfo,
      renderMode: renderingMode,
      language: Locale.preferredLanguageCode() ?? "en",
      shouldPersistWebsiteDataToDisk: false,
      disableZoom: renderOptions.disableZoom,
      linkedOfferId: renderOptions.linkedOfferId
    ) {
      rendererView.rendererDelegate = self
      rendererView.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(rendererView)
      self.rendererView = rendererView

      setupFooter()
      setupConstraints()

      // Reserve scroll space for the native footer overlaying the publication.
      rendererView.bottomContentInset = Self.footerHeight
    }

    spinner.stopAnimating()
  }

  /// Prefer location-based rendering when a postal + country code were provided,
  /// otherwise fall back to merchant/store.
  private func makePublicationInfo() -> PublicationInfo? {
    if let postalCode = renderOptions.postalCode, let countryCode = renderOptions.countryCode {
      return .byLocation(postalCode: postalCode, countryCode: countryCode)
    }
    if let merchantId, let storeCode {
      return .byMerchant(merchantId: merchantId, storeCode: storeCode)
    }
    return nil
  }

  private func setupFooter() {
    footerView.translatesAutoresizingMaskIntoConstraints = false
    footerView.backgroundColor = .primary3
    statusLabel.translatesAutoresizingMaskIntoConstraints = false
    statusLabel.textColor = .default0
    statusLabel.font = .systemFont(ofSize: 13)
    statusLabel.numberOfLines = 1
    statusLabel.adjustsFontSizeToFitWidth = true
    statusLabel.text = "Ready"
    footerView.addSubview(statusLabel)
    view.addSubview(footerView)
  }

  private func setupConstraints() {
    guard let rendererView else { return }
    NSLayoutConstraint.activate([
      rendererView.topAnchor.constraint(equalTo: view.topAnchor),
      rendererView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      rendererView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      rendererView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

      footerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      footerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      footerView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
      footerView.heightAnchor.constraint(equalToConstant: Self.footerHeight),

      statusLabel.leadingAnchor.constraint(equalTo: footerView.leadingAnchor, constant: 12),
      statusLabel.trailingAnchor.constraint(equalTo: footerView.trailingAnchor, constant: -12),
      statusLabel.centerYAnchor.constraint(equalTo: footerView.centerYAnchor),
    ])
  }

  private func setStatus(_ text: String) {
    statusLabel.text = text
    Self.logger.debug("\(text, privacy: .public)")
  }

  func pushDetailsController(for offer: Offer) {
    let detailsController = OfferDetailsViewHostController(offer: offer)
    self.present(
      UINavigationController(rootViewController: detailsController),
      animated: true)
  }
}

extension PublicationViewController: DVMRendererDelegate {
  func didFinishLoad(legacyMap: [String: String]) {
    setStatus("Loaded")
  }

  func didFailToLoad(error: Error) {
    setStatus("Failed to load: \(error.localizedDescription)")
  }

  // MARK: Offers

  func didTap(result: Result<Offer, DVMSDKError>) {
    switch result {
    case .success(let offer):
      pushDetailsController(for: offer)
    case .failure(let error):
      setStatus("Tap error: \(error.localizedDescription)")
    }
  }

  func didLongTap(result: Result<Offer?, DVMSDKError>) {
    if case .success(let offer?) = result {
      setStatus("Long tapped: \(offer.name ?? offer.id)")
      pushDetailsController(for: offer)
    }
  }

  func publicationImpression(ids: [String]) {
    setStatus("Offer impressions: \(ids.count)")
  }

  // MARK: Promotions

  func didTapPromotion(result: Result<Promotion, DVMSDKError>) {
    switch result {
    case .success(let promotion):
      setStatus("Tapped promotion: \(promotion.name ?? promotion.id)")
    case .failure(let error):
      setStatus("Promotion tap error: \(error.localizedDescription)")
    }
  }

  func publicationScrollToPromotionResponse(_ promotion: Promotion) {
    setStatus("Scrolled to promotion: \(promotion.name ?? promotion.id)")
  }

  func publicationPromotionImpression(ids: [String]) {
    setStatus("Promotion impressions: \(ids.count)")
  }

  // MARK: Through-the-merchant links

  func didTapTTM(url: URL) {
    setStatus("TTM tapped: \(url.absoluteString)")
    UIApplication.shared.open(url)
  }

  // MARK: Linked-offer / hydration strategy results

  func didReceiveStrategyResults(_ results: [StrategyResult]) {
    if let failure = results.first(where: { $0.errorMessage != nil }) {
      let message = failure.errorMessage ?? "unknown error"
      setStatus("Strategy error: \(message)")
      let alert = UIAlertController(title: "Linked offer not loaded", message: message, preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "OK", style: .default))
      present(alert, animated: true)
    } else {
      setStatus("Strategy results: \(results.count) ok")
    }
  }

  // MARK: Scroll telemetry

  func publicationDidScroll(contentOffset: CGPoint, contentSize: CGSize, viewportHeight: CGFloat) {
    let scrollable = max(contentSize.height - viewportHeight, 1)
    let progress = min(max(contentOffset.y / scrollable, 0), 1)
    setStatus(String(format: "Scroll: %.0f%%", progress * 100))
  }

  func publicationDidEndDragging(willDecelerate: Bool) {
    Self.logger.debug("Did end dragging, willDecelerate: \(willDecelerate)")
  }

  func publicationDidEndDecelerating() {
    Self.logger.debug("Did end decelerating")
  }
}
