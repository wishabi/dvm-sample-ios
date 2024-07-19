// Copyright © 2024 Flipp. All rights reserved.

import dvm_sdk
import UIKit

class PublicationsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  var publications: [Publication] = []
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
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()

  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
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
    DVMSDK.fetchPublicationsList(
      merchantId: merchantID,
      storeCode: storeCode) {[weak self] list, error in
        if let error {
          //inform error or add retry logic.
          print(error)
          return
        }
        self?.publications = list.publications
        self?.tableView.reloadData()
        // store next page token for infinite scroll
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
    return publications.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
    let publication = publications[indexPath.row]
    cell.textLabel?.text = publication.core.details.name
    cell.detailTextLabel?.text = publication.globalID
    return cell
  }

  // MARK: - UITableViewDelegate

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    let publication = publications[indexPath.row]
    let publicationVC = PublicationViewController()
    let renderingMode = segmentedControl.selectedSegmentIndex == 0 ? RenderMode.sfml : RenderMode.dvm
    publicationVC.publicationID = publication.globalID
    publicationVC.merchantId = self.merchantID
    publicationVC.storeCode = self.storeCode
    publicationVC.renderingMode = renderingMode
    navigationController?.pushViewController(publicationVC, animated: true)
  }
}
