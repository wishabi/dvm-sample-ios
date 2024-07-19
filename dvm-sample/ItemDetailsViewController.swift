// Copyright © 2024 Flipp. All rights reserved.

import dvm_sdk
import UIKit

class ItemDetailsViewController: UIViewController {
  let offer: Offer

  let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    return dateFormatter
  }()

  let detailsLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: 24)
    label.textAlignment = .center
    label.text = "Item Details"
    return label
  }()

  let centralImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()

  let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 16)
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()

  let descriptionTitleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: 18)
    label.textAlignment = .left
    label.numberOfLines = 0
    label.text = "Description"
    return label
  }()

  let descriptionLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 12)
    label.textAlignment = .left
    label.numberOfLines = 0
    return label
  }()

  let priceLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: 20)
    label.textAlignment = .left
    label.textColor = .systemRed
    return label
  }()

  let validLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: 14)
    label.numberOfLines = 0
    label.textAlignment = .left
    return label
  }()

  init(offer: Offer) {
    self.offer = offer
    super.init(nibName: nil, bundle: nil)
  }

  @available(*, unavailable)
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    view.backgroundColor = .white
    super.viewDidLoad()
    setupViews()
//    temporary until image permission are sorted out.
//    if let urlString = offer.details?.en?.imageURL,
//       let url = URL(string: urlString) {
//      self.centralImageView.loadImage(from: url)
//    }
    self.centralImageView.image = UIImage(named: "sample")

    if let name = offer.details?.en?.name {
      self.titleLabel.text = name
    }
    let prePrice =  offer.offerDetails?.en?.prePriceText ?? ""
    if let price = offer.pricing?.price {
      self.priceLabel.text = "\(prePrice)$\(price)"
    }
    if let validToDate = offer.dates?.validTo,
       let validFromDate = offer.dates?.validFrom {
      var validLabelText = ""
      if let salesStory = offer.offerDetails?.en?.saleStory {
        validLabelText.append("\(salesStory)\n")
      }
      let validTo = dateFormatter.string(from: validToDate)
      let validFrom = dateFormatter.string(from: validFromDate)
      validLabelText.append("Valid: \(validFrom) - \(validTo)")
      self.validLabel.text = validLabelText
    }
    var descriptionLabelText = ""
    if let description = offer.details?.en?.description {
      descriptionLabelText.append("\(description)\n")
    }
    if let sku = offer.details?.en?.additionalInfo?.sku {
      descriptionLabelText.append("SKU: \(sku)")
    }
    self.descriptionLabel.text = descriptionLabelText
  }

  private func setupViews() {
    view.addSubview(titleLabel)
    view.addSubview(centralImageView)
    view.addSubview(detailsLabel)
    view.addSubview(descriptionTitleLabel)
    view.addSubview(descriptionLabel)
    view.addSubview(priceLabel)
    view.addSubview(validLabel)

    setupConstraints()
  }

  private func setupConstraints() {
    NSLayoutConstraint.activate([
      detailsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
      detailsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      detailsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

      centralImageView.topAnchor.constraint(equalTo: detailsLabel.bottomAnchor, constant: 20),
      centralImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      centralImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      centralImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.3),

      titleLabel.topAnchor.constraint(equalTo: centralImageView.bottomAnchor, constant: 20),
      titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

      priceLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
      priceLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      priceLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      priceLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20),

      validLabel.topAnchor.constraint(equalTo: priceLabel.bottomAnchor, constant: 20),
      validLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      validLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
      validLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20),

      descriptionTitleLabel.topAnchor.constraint(equalTo: validLabel.bottomAnchor, constant: 20),
      descriptionTitleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      descriptionTitleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

      descriptionLabel.topAnchor.constraint(equalTo: descriptionTitleLabel.bottomAnchor, constant: 10),
      descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
      descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
    ])
  }
}

import UIKit

extension UIImageView {
  // Very rudimentary implementation
  func loadImage(from url: URL, placeholder: UIImage? = nil) {
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      if let data = data, error == nil, let image = UIImage(data: data) {
        DispatchQueue.main.async {
          self.image = image
        }
      }
    }
    task.resume()
  }
}
