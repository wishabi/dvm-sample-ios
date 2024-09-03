//
//  SectionHeader.swift
//  dvm-sample
//
//  Created by William Chang on 2024-08-29.
//

import UIKit

class SectionHeader: UITableViewHeaderFooterView {
  let label: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  override init(reuseIdentifier: String?) {
    super.init(reuseIdentifier: reuseIdentifier)

    addSubview(label)
    NSLayoutConstraint.activate([
      label.leadingAnchor.constraint(equalTo: readableContentGuide.leadingAnchor),
      label.trailingAnchor.constraint(equalTo: readableContentGuide.trailingAnchor),
      label.topAnchor.constraint(equalTo: readableContentGuide.topAnchor),
      label.bottomAnchor.constraint(equalTo: readableContentGuide.bottomAnchor)
    ])
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
