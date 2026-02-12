//
//  PublicationCell.swift
//  dvm-sample
//
//  Created by William Chang on 2024-08-29.
//

import UIKit

protocol PublicationCellDelegate: NSObjectProtocol {
  func didTapSFMLButton(cell: UITableViewCell)
  func didTapDVMButton(cell: UITableViewCell)
}

class PublicationCell: UITableViewCell {
  static let reuseIdentifier = "PublicationCell"

  weak var delegate: PublicationCellDelegate?

  lazy var mainStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.spacing = 8
    stackView.axis = .vertical
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  lazy var buttonsStackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .horizontal
    stackView.spacing = 8
    stackView.distribution = .fillEqually
    stackView.alignment = .fill
    stackView.translatesAutoresizingMaskIntoConstraints = false
    return stackView
  }()

  lazy var topStackView: UIStackView = {
    let view = UIStackView()
    view.isLayoutMarginsRelativeArrangement = true
    view.layoutMargins = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    view.alignment = .center
    view.spacing = 8
    view.axis = .horizontal
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  lazy var infoContainerStackView = {
    let view = UIStackView()
    view.isLayoutMarginsRelativeArrangement = true
    view.spacing = 8
    view.axis = .vertical
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  lazy var cellImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
    imageView.clipsToBounds = true
    imageView.layer.cornerRadius = 8
    return imageView
  }()

  lazy var titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.textColor = .default5
    label.font = UIFont.boldSystemFont(ofSize: 18)
    return label
  }()

  lazy var subtitleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .default5
    return label
  }()

  lazy var validLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .default5
    return label
  }()

  lazy var tagsLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = .default5
    return label
  }()

  lazy var sfmlButton: UIButton = {
    var buttonConfig = UIButton.Configuration.bordered()
    buttonConfig.title = "View SFML"
    let sfmlButton = UIButton(configuration: buttonConfig)
    return sfmlButton
  }()

  lazy var dvmButton: UIButton = {
    var buttonConfig = UIButton.Configuration.bordered()
    buttonConfig.title = "View DVM"
    let dvmButton = UIButton(configuration: buttonConfig)
    return dvmButton
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    selectionStyle = .none
    setupViews()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupViews() {
    self.backgroundColor = .appBackground

    contentView.addSubview(mainStackView)

    mainStackView.addArrangedSubview(topStackView)
    mainStackView.addArrangedSubview(buttonsStackView)

    sfmlButton.addTarget(self, action: #selector(didTapSFMLButton), for: .touchUpInside)

    dvmButton.addTarget(self, action: #selector(didTapDVMButton), for: .touchUpInside)

    buttonsStackView.addArrangedSubview(sfmlButton)
    buttonsStackView.addArrangedSubview(dvmButton)

    topStackView.addArrangedSubview(cellImageView)
    topStackView.addArrangedSubview(infoContainerStackView)

    infoContainerStackView.addArrangedSubview(titleLabel)
    infoContainerStackView.addArrangedSubview(subtitleLabel)
    infoContainerStackView.addArrangedSubview(validLabel)
    infoContainerStackView.addArrangedSubview(tagsLabel)
    setupConstraints()
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      mainStackView.leadingAnchor.constraint(equalTo: contentView.readableContentGuide.leadingAnchor),
      mainStackView.trailingAnchor.constraint(equalTo: contentView.readableContentGuide.trailingAnchor),
      mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor),
      mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
      cellImageView.widthAnchor.constraint(equalToConstant: 60),
      cellImageView.heightAnchor.constraint(equalToConstant: 60),

      buttonsStackView.heightAnchor.constraint(equalToConstant: 44),
    ])
  }

  @objc private func didTapSFMLButton() {
    delegate?.didTapSFMLButton(cell: self)
  }

  @objc private func didTapDVMButton() {
    delegate?.didTapDVMButton(cell: self)
  }

  public func markSFMLAvailable(_ available: Bool) {
    sfmlButton.isEnabled = available
  }

  public func markDVMAvailable(_ available: Bool) {
    dvmButton.isEnabled = available
  }
}
