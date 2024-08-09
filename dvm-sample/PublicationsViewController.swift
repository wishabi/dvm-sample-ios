// Copyright © 2024 Flipp. All rights reserved.

import dvm_sdk
import UIKit

class PublicationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  var publications: PublicationsList?
  var merchantID: String?
  var storeCode: String?

  let segmentedControl: UISegmentedControl = {
    let control = UISegmentedControl(items: ["SFML", "DVM"])
    control.translatesAutoresizingMaskIntoConstraints = false
    control.selectedSegmentIndex = 0
    return control
  }()

  let tableView: UITableView = {
    let tableView = UITableView()
    tableView.backgroundColor = .clear
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .appBackground
    title = "Publications"
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    view.addSubview(tableView)
    view.addSubview(segmentedControl)
    setupConstraints()
  }

  override func viewDidAppear(_ animated: Bool) {
    guard let merchantID, let storeCode else { return }
    Task.detached {
      let publications = try? await DVMSDK.fetchPublicationsList(merchantId: merchantID, storeCode: storeCode)
      await MainActor.run {
        self.publications = publications
        self.tableView.reloadData()
      }
    }
  }

  func setupConstraints() {
    NSLayoutConstraint.activate([
      segmentedControl.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
      segmentedControl.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      segmentedControl.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
    ])
  }

  // MARK: - UITableViewDataSource

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return publications?.publications.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let publications = publications?.publications else {
      return UITableViewCell()
    }
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

    cell.backgroundColor = .default0
    cell.textLabel?.textColor = .default5
    let publication = publications[indexPath.row]
    cell.textLabel?.text = publication.details.name
    cell.detailTextLabel?.text = publication.globalID
    return cell
  }

  // MARK: - UITableViewDelegate

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let publications = publications?.publications else {
      return 
    }
    tableView.deselectRow(at: indexPath, animated: true)
    let publication = publications[indexPath.row]
    let publicationVC = PublicationViewController()
    let renderingMode = segmentedControl.selectedSegmentIndex == 0 ? RenderMode.sfml : RenderMode.dvm
    publicationVC.publicationID = publication.globalID
    publicationVC.merchantId = self.merchantID
    publicationVC.storeCode = self.storeCode
    publicationVC.renderingMode = renderingMode
    publicationVC.view.backgroundColor = .red
    navigationController?.pushViewController(publicationVC, animated: true)
  }

  func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    return "Publications"
  }
}
