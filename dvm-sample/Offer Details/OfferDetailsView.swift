//
//  OfferDetailsView.swift
//  dvm-sample
//
//  Created by William Chang on 2024-08-27.
//

import dvm_sdk
import SwiftUI

struct OfferDetailsView: View {
  @ObservedObject var viewModel: OfferDetailsViewModel

  var body: some View {
    ScrollView(.vertical, showsIndicators: true) {
      VStack(alignment: .leading, spacing: 16) {
        if !viewModel.imageURLStrings.isEmpty {
          if viewModel.imageURLStrings.count == 1 {
            offerImage(viewModel.imageURLStrings[0])
          } else {
            ScrollView(.horizontal, showsIndicators: true) {
              HStack(spacing: 16) {
                ForEach(viewModel.imageURLStrings, id: \.self) { offerImage($0) }
              }
            }
          }
        }

        if let name = viewModel.name, !name.isEmpty {
          Text(name)
            .bold()
            .font(.title2)
        }

        VStack(alignment: .leading, spacing: 4) {
          Text("Price")
            .font(.headline)
          HStack(spacing: 4) {
            if let prePrice = viewModel.prePriceText, !prePrice.isEmpty {
              Text(prePrice)
            }
            Text(viewModel.priceText)
              .bold()
              .font(.title2)
              .foregroundStyle(.red)
            if let postPrice = viewModel.postPriceText, !postPrice.isEmpty {
              Text(postPrice)
            }
          }
          if let saleStory = viewModel.saleStory, !saleStory.isEmpty {
            Text(saleStory)
              .font(.subheadline)
              .foregroundStyle(.secondary)
          }
        }

        Text(viewModel.validity)

        if let description = viewModel.description, !description.isEmpty {
          VStack(alignment: .leading) {
            Text("Description")
              .font(.title3)
            Text(description)
          }
        }

        if let disclaimer = viewModel.disclaimer, !disclaimer.isEmpty {
          Text(disclaimer)
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
      }
      .padding()
    }
    .navigationTitle("Offer Details")
  }

  private func offerImage(_ urlString: String) -> some View {
    AsyncImage(url: URL(string: urlString)) { image in
      image.image?
        .resizable()
        .aspectRatio(contentMode: .fit)
    }
    .frame(maxWidth: .infinity, maxHeight: 200, alignment: .center)
  }
}

#Preview {
  OfferDetailsView(
    viewModel: OfferDetailsViewModel(
      imageURLStrings: [],
      name: "Sample Offer",
      priceText: "$4.99",
      prePriceText: "Now",
      postPriceText: "each",
      saleStory: "SAVE BIG",
      validity: "Valid: Aug 1 - Aug 31",
      description: "A tasty sample offer.",
      disclaimer: "While supplies last."))
}

class OfferDetailsViewModel: ObservableObject {
  static let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    return dateFormatter
  }()

  let imageURLStrings: [String]
  let name: String?
  let priceText: String
  let prePriceText: String?
  let postPriceText: String?
  let saleStory: String?
  let validity: String
  let description: String?
  let disclaimer: String?

  init(
    imageURLStrings: [String],
    name: String?,
    priceText: String,
    prePriceText: String?,
    postPriceText: String?,
    saleStory: String?,
    validity: String,
    description: String?,
    disclaimer: String?
  ) {
    self.imageURLStrings = imageURLStrings
    self.name = name
    self.priceText = priceText
    self.prePriceText = prePriceText
    self.postPriceText = postPriceText
    self.saleStory = saleStory
    self.validity = validity
    self.description = description
    self.disclaimer = disclaimer
  }

  convenience init(from offer: Offer) {
    self.init(
      imageURLStrings: offer.imageURLs,
      name: offer.name,
      priceText: Self.priceText(for: offer.pricing),
      prePriceText: offer.prePriceText,
      postPriceText: offer.postPriceText,
      saleStory: offer.saleStory,
      validity: Self.validity(from: offer.validFrom, to: offer.validTo),
      description: offer.description,
      disclaimer: offer.disclaimer)
  }

  /// Composes a display price from the available pricing fields, preferring an
  /// explicit sale/regular price, then falling back to a percentage/amount off.
  private static func priceText(for pricing: OfferPricing?) -> String {
    guard let pricing else { return "" }
    if let salePrice = pricing.salePrice {
      return String(format: "$%.2f", salePrice)
    } else if let price = pricing.price {
      return String(format: "$%.2f", price)
    } else if let percentOff = pricing.percentOff {
      return String(format: "%.0f%% OFF", percentOff)
    } else if let amountOff = pricing.amountOff {
      return String(format: "$%.2f OFF", amountOff)
    }
    return ""
  }

  private static func validity(from: Date?, to: Date?) -> String {
    var validity = "Valid: "
    if let from {
      validity.append(dateFormatter.string(from: from))
      validity.append(" - ")
    }
    if let to {
      validity.append(dateFormatter.string(from: to))
    }
    return validity
  }
}
