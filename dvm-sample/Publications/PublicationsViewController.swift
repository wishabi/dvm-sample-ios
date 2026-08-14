// Copyright © 2024 Flipp. All rights reserved.

import dvm_sdk
import OSLog
import UIKit

class PublicationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  static let logger = Logger(
    subsystem: Bundle.main.bundleIdentifier!,
    category: String(describing: PublicationsViewController.self))

  let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    return dateFormatter
  }()

  var publications: [Publication] = []
  var merchantID: String?
  var storeCode: String?
  var renderOptions = RenderOptions(disableZoom: false, linkedOfferId: nil, postalCode: nil, countryCode: nil)

  let tableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .clear
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .appBackground
    title = "Merchant \(merchantID ?? ""), Store \(storeCode ?? "")"

    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    tableView.register(PublicationCell.self, forCellReuseIdentifier: PublicationCell.reuseIdentifier)
    tableView.register(SectionHeader.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")

    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(fetchPublications), for: .valueChanged)
    tableView.refreshControl = refreshControl

    view.addSubview(tableView)
    setupConstraints()

    fetchPublications()
  }

  @objc private func fetchPublications() {
    guard let merchantID else { return }

    tableView.refreshControl?.beginRefreshing()

    let storeCode = self.storeCode
    let postalCode = renderOptions.postalCode
    let countryCode = renderOptions.countryCode
    let language = Locale.preferredLanguageCode() ?? "en"

    Task.detached {
      do {
        let publications: [Publication]
        if let postalCode, let countryCode {
          // Location-based listing: fetch the merchant's publications near a postal
          // code, no store required.
          publications = try await DVMSDK.fetchPublicationsList(
            merchantId: merchantID,
            postalCode: postalCode,
            countryCode: countryCode,
            language: language)
        } else {
          // Store-based listing. storeCode is optional: when nil, all of the merchant's
          // publications are returned.
          publications = try await DVMSDK.fetchPublicationsList(
            merchantId: merchantID,
            storeCode: storeCode,
            language: language)
        }
        await MainActor.run { [weak self] in
          self?.tableView.refreshControl?.endRefreshing()
          self?.publications = publications
          self?.tableView.reloadData()
        }
      } catch {
        await MainActor.run { [weak self] in
            self?.tableView.refreshControl?.endRefreshing()
        }
        await Self.logger.error("Error fetching publications: \(error.localizedDescription)")
      }
    }
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ])
  }

  // MARK: - UITableViewDataSource

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    guard !publications.isEmpty else {
      return nil
    }
    let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as? SectionHeader
    view?.label.text = "\(publications.count) publication(s)"
    return view
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return publications.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: PublicationCell.reuseIdentifier, for: indexPath) as? PublicationCell else {
      fatalError("Bad cell")
    }

    cell.delegate = self

    let publication = publications[indexPath.row]
    if let urlString = publication.imageURL,
       let url = URL(string: urlString) {
      cell.cellImageView.loadImage(from: url)
      cell.cellImageView.isHidden = false
    } else {
      cell.cellImageView.image = nil
      cell.cellImageView.isHidden = true
    }
    cell.titleLabel.text = publication.name ?? ""
    if let description = publication.description {
      cell.subtitleLabel.text = description
    } else {
      cell.subtitleLabel.text = ""
    }
    if let validFrom = publication.validFrom,
       let validTo = publication.validTo {
      cell.validLabel.text = "Valid: \(dateFormatter.string(from: validFrom)) - \(dateFormatter.string(from: validTo))"
    } else {
      cell.validLabel.text = ""
    }

    let tags = publication.tags.joined(separator: ", ")
    cell.tagsLabel.text = "Tags: \(tags.isEmpty ? "No tags" : tags)"
    
    cell.markDVMAvailable(publication.renderingTypes.contains(where: { $0 == .dvm }))
    cell.markSFMLAvailable(publication.renderingTypes.contains(where: { $0 == .sfml }))
    return cell
  }

  // MARK: - UITableViewDelegate

  private func showPublication(_ publication: Publication, mode: RenderMode) {
    let publicationVC = PublicationViewController()
    publicationVC.publicationID = publication.id
    publicationVC.merchantId = self.merchantID
    publicationVC.storeCode = self.storeCode
    publicationVC.renderingMode = mode
    publicationVC.renderOptions = self.renderOptions
    navigationController?.pushViewController(publicationVC, animated: true)
  }
}

extension PublicationsViewController: PublicationCellDelegate {
  func didTapSFMLButton(cell: UITableViewCell) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }

    guard indexPath.row < publications.count else {
      return
    }

    showPublication(publications[indexPath.row], mode: .sfml)
  }

  func didTapDVMButton(cell: UITableViewCell) {
    guard let indexPath = tableView.indexPath(for: cell) else {
      return
    }

    guard indexPath.row < publications.count else {
      return
    }

    showPublication(publications[indexPath.row], mode: .dvm)
  }
}
