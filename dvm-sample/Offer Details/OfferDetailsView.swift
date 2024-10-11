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
    ScrollView(
      .vertical,
      showsIndicators: true) {
        VStack(
          alignment: .leading,
          spacing: 16,
          content: {
            if viewModel.imageURLStrings.count > 0 {
              if viewModel.imageURLStrings.count == 1 {
                AsyncImage(url: URL(string: viewModel.imageURLStrings.first!)!) { image in
                  image.image?
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                }
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 200, alignment: .center)
              } else {
                ScrollView(.horizontal, showsIndicators: true) {
                  HStack(spacing: 16) {
                    ForEach(viewModel.imageURLStrings, id: \.self) { imageURLString in
                      AsyncImage(url: URL(string: imageURLString)!) { image in
                        image.image?
                          .resizable()
                          .aspectRatio(contentMode: .fit)
                      }
                      .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 200, alignment: .center)
                    }
                  }
                }
              }
            }

            if let name = viewModel.name, !name.isEmpty {
              Text(name)
                .bold()
                .font(.title2)
            }

            VStack(alignment: .leading) {
              Text("V1 Price composition")
              HStack(spacing: 4) {
                Text(viewModel.v1Price ?? "")
                  .bold()
                  .font(.title2)
                  .foregroundStyle(.red)

                Text(viewModel.v1PostPrice ?? "")
              }
              Text("V1 sale story: \(viewModel.v1SaleStory ?? "")")
            }
            VStack(alignment: .leading) {
              Text("V2 Price composition")
              HStack(spacing: 4) {
                Text(viewModel.v2Price ?? "")
                  .bold()
                  .font(.title2)
                  .foregroundStyle(.red)

                Text(viewModel.v2PostPrice ?? "")
              }
              Text("V2 sale story: \(viewModel.v2SaleStory ?? "")")
            }
            Text(viewModel.validity)

            if let description = viewModel.description, !description.isEmpty {
              VStack(
                alignment: .leading) {
                  Text("Description")
                    .font(.title3)

                  Text(description)
                }
            }

            if let disclaimer = viewModel.disclaimer {
              Text(disclaimer)
            }

            Text(viewModel.sku)
          })
        .padding()
      }
      .navigationTitle("Offer Details")
  }
}

#Preview {
  OfferDetailsView(
    viewModel:
      OfferDetailsViewModel(
        imageURLStrings: [
          "https://flipp-image-retrieval.flipp.com/api/aHR0cDovL2Yud2lzaGFiaS5uZXQvcGFnZV9wZGZfaW1hZ2VzLzE4NTY1MTYzL2ZlODQwNTc2LTIyMWItMTFlZi1hMjRhLTBlZGM1M2MyNWVlNi94X2xhcmdl?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9mbGlwcC1pbWFnZS1yZXRyaWV2YWwuZmxpcHAuY29tL2FwaS9hSFIwY0RvdkwyWXVkMmx6YUdGaWFTNXVaWFF2Y0dGblpWOXdaR1pmYVcxaFoyVnpMekU0TlRZMU1UWXpMMlpsT0RRd05UYzJMVEl5TVdJdE1URmxaaTFoTWpSaExUQmxaR00xTTJNeU5XVmxOaTk0WDJ4aGNtZGw~KiIsIkNvbmRpdGlvbiI6eyJEYXRlTGVzc1RoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTcyNTM3NzE1OH19fV19&Signature=eMbd2O~JaqWnWOTFL6TST6AQy1zQTzKofrA0Zkw808JDqjwVlk1CNjLlSQuZk4E7MjU22gWN1au6oP7NIgWGX6e07hwjStaT14M8wWnHZLq-eXAREdef8DGutvEjj9zx6jnE6vAEnUKkejTGL8ETRjenVAIL99oXyN~QU-VZXzE-fSBtnjsWeFu-uFq891OGmpu8sQIPIfwSRxWrObOn0-olCiVEz0oidzkBM2sMfsqXs-TsLt4rWBqB6zaJow9YH5UmkbvYWeLhMMIZD7bb9TQI~ZDylWp14L0tKB2DcHzJoBg~3ts14jlwItYl7sWjR1WG6SiQ91Ax0HQ7ASmM8w__&Key-Pair-Id=KDIF3067XOLU0",
          "https://flipp-image-retrieval.flipp.com/api/aHR0cDovL2Yud2lzaGFiaS5uZXQvcGFnZV9wZGZfaW1hZ2VzLzE4NTY1MTYzL2ZlODQwNTc2LTIyMWItMTFlZi1hMjRhLTBlZGM1M2MyNWVlNi94X2xhcmdl?Policy=eyJTdGF0ZW1lbnQiOlt7IlJlc291cmNlIjoiaHR0cHM6Ly9mbGlwcC1pbWFnZS1yZXRyaWV2YWwuZmxpcHAuY29tL2FwaS9hSFIwY0RvdkwyWXVkMmx6YUdGaWFTNXVaWFF2Y0dGblpWOXdaR1pmYVcxaFoyVnpMekU0TlRZMU1UWXpMMlpsT0RRd05UYzJMVEl5TVdJdE1URmxaaTFoTWpSaExUQmxaR00xTTJNeU5XVmxOaTk0WDJ4aGNtZGw~KiIsIkNvbmRpdGlvbiI6eyJEYXRlTGVzc1RoYW4iOnsiQVdTOkVwb2NoVGltZSI6MTcyNTM3NzE1OH19fV19&Signature=eMbd2O~JaqWnWOTFL6TST6AQy1zQTzKofrA0Zkw808JDqjwVlk1CNjLlSQuZk4E7MjU22gWN1au6oP7NIgWGX6e07hwjStaT14M8wWnHZLq-eXAREdef8DGutvEjj9zx6jnE6vAEnUKkejTGL8ETRjenVAIL99oXyN~QU-VZXzE-fSBtnjsWeFu-uFq891OGmpu8sQIPIfwSRxWrObOn0-olCiVEz0oidzkBM2sMfsqXs-TsLt4rWBqB6zaJow9YH5UmkbvYWeLhMMIZD7bb9TQI~ZDylWp14L0tKB2DcHzJoBg~3ts14jlwItYl7sWjR1WG6SiQ91Ax0HQ7ASmM8w__&Key-Pair-Id=KDIF3067XOLU0"
        ],
        v1Price: "Price",
        v2Price: "Price",
        v1PostPrice: "Post price v1",
        v2PostPrice: "Post price v2",
        validity: "Valid from a - b",
        name: "Name",
        v1SaleStory: "Sale story v1",
        v2SaleStory: "Sale story v2",
        description: "Description",
        sku: "SKU",
        disclaimer: "Disclaimer"))
}

class OfferDetailsViewModel: ObservableObject {
  static let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.dateStyle = .medium
    return dateFormatter
  }()

  let imageURLStrings: [String]
  let v1Price: String?
  let v1PostPrice: String?
  let v2Price: String?
  let v2PostPrice: String?
  let validity: String
  let name: String?
  let v1SaleStory: String?
  let v2SaleStory: String?
  let description: String?
  let sku: String
  let disclaimer: String?

  init(imageURLStrings: [String],
       v1Price: String?,
       v2Price: String?,
       v1PostPrice: String?,
       v2PostPrice: String?,
       validity: String,
       name: String?,
       v1SaleStory: String?,
       v2SaleStory: String?,
       description: String?,
       sku: String,
       disclaimer: String?) {
    self.imageURLStrings = imageURLStrings
    self.v1Price = v1Price
    self.v2Price = v2Price
    self.v1PostPrice = v1PostPrice
    self.v2PostPrice = v2PostPrice
    self.validity = validity
    self.name = name
    self.v1SaleStory = v1SaleStory?.isEmpty == false ? v1SaleStory : nil
    self.v2SaleStory = v2SaleStory?.isEmpty == false ? v2SaleStory : nil
    self.description = description?.isEmpty == false ? description : nil
    self.sku = sku
    self.disclaimer = disclaimer
  }

  convenience init(from offer: Offer) {
    var validity = "Valid: "

    if let validFrom = offer.dates?.validFrom {
      validity.append(Self.dateFormatter.string(from: validFrom))
      validity.append(" - ")
    }

    if let validTo = offer.dates?.validTo {
      validity.append(Self.dateFormatter.string(from: validTo))
    }

    var v1PriceString = ""

    if let prePrice = offer.offerDetails?.prePriceText, !prePrice.isEmpty {
      v1PriceString.append(prePrice)
      v1PriceString.append(" ")
    }

    if let price = offer.pricing?.salePrice {
      v1PriceString.append("$\(price)")
    } else if let price = offer.pricing?.price {
      v1PriceString.append("$\(price)")
    }

    var imageURLStrings = [String]()

    if let imageURL = offer.details?.imageURL {
      imageURLStrings.append(imageURL)
    }

    if let additionalImages = offer.details?.additionalMedia?.compactMap({ $0.url }) {
      imageURLStrings.append(contentsOf: additionalImages)
    }

    let pricingTexts = Self.v1PriceTextMappingFromV2English(offer: offer)

    var v2PriceString = ""

    if !pricingTexts.prePrice.isEmpty {
      v2PriceString.append(pricingTexts.prePrice)
      v2PriceString.append(" ")
    }

    v2PriceString.append("\(pricingTexts.price)")

    self.init(
      imageURLStrings: imageURLStrings,
      v1Price: v1PriceString.isEmpty == false ? v1PriceString : nil,
      v2Price: v2PriceString,
      v1PostPrice: offer.offerDetails?.postPriceText,
      v2PostPrice: pricingTexts.postPrice,
      validity: validity,
      name: offer.details?.name,
      v1SaleStory: offer.offerDetails?.saleStory,
      v2SaleStory: Self.v1SalesStoryMappingFromV2English(offer: offer),
      description: offer.details?.description,
      sku: "SKU: \(offer.details?.additionalInfo["sku"] ?? "")",
      disclaimer: offer.offerDetails?.disclaimer)
  }


  // Compose V1 fields from V2 mappings.
  static func v1SalesStoryMappingFromV2English(offer: Offer) -> String {
    let labels = offer.pricing?.labels
    var saleStory = offer.offerDetails?.saleStory ?? ""
    let pricing = offer.pricing
    let prePriceText = offer.offerDetails?.prePriceText ?? ""

    // "Save" Labels
    if let labels = labels, labels.contains("show-save") {
      saleStory = "SAVE \(saleStory)"
    }

    // Qualifying Quantity
    if offer.pricing?.offerType == .buyXgetY,
       let percentOff = pricing?.percentOff,
       let qualifyingQuantity = pricing?.qualifyingQuantity,
       let rewardQuantity = pricing?.rewardQuantity {
      if !saleStory.isEmpty {
        saleStory += " "
      }
      saleStory += "BUY \(qualifyingQuantity) GET \(rewardQuantity) \(percentOff)% OFF"
    } else if let qualifyingQuantity = pricing?.qualifyingQuantity,
              !(prePriceText.range(of: "Buy \\d+ Or More", options: .regularExpression) != nil) {
      if !saleStory.isEmpty {
        saleStory += " "
      }
      saleStory += "WHEN YOU BUY \(qualifyingQuantity)"
    }

    // Loyalty
    if let loyaltyPoints = pricing?.loyaltyPoints {
      if !saleStory.isEmpty {
        saleStory += ", "
      }
      saleStory += "PC Optimum \(loyaltyPoints) pts"

      if let loyaltyPointsStory = offer.details?.additionalInfo["loyaltyPointsStory"] as? String,
         !loyaltyPointsStory.isEmpty {
        saleStory += " \(loyaltyPointsStory)"
      }
      if let loyaltyValue = offer.details?.additionalInfo["loyaltyPointsValue"] {
        saleStory += ", $\(loyaltyValue) Value"
      }
    }

    return saleStory
  }

  // Compose v1 sales story from v2 mappings.
  static func v1PriceTextMappingFromV2English(offer: Offer) -> (prePrice: String, price: String, postPrice: String, wasPrice: String) {
    let offerDetails = offer.offerDetails
    let pricing = offer.pricing

    let prePriceText = offerDetails?.prePriceText ?? ""
    var priceText = ""
    var wasPriceText = ""
    let postPriceText = offerDetails?.postPriceText ?? ""

    // Get the price text
    let priceRange = pricing?.salePriceRange ?? pricing?.priceRange
    let price = pricing?.salePrice ?? pricing?.price
    if let range = priceRange {
      priceText = "$\(String(format: "%.2f", range.from)) - $\(String(format: "%.2f", range.to))"
    } else if let price = price {
      priceText = "$\(String(format: "%.2f", price))"
    } else if pricing?.offerType == .percentOff, let percentOff = pricing?.percentOff {
      priceText = "\(percentOff)% OFF"
    } else if pricing?.offerType == .amountOff, let amountOff = pricing?.amountOff {
      priceText = "$\(amountOff) OFF"
    }

    let wasPriceRange = pricing?.salePriceRange != nil ? pricing?.priceRange : nil
    let wasPrice = pricing?.salePrice != nil ? pricing?.price : nil
    if let range = wasPriceRange {
      wasPriceText = "$\(String(format: "%.2f", range.from)) - $\(String(format: "%.2f", range.to))"
    } else if let price = wasPrice {
      wasPriceText = "$\(String(format: "%.2f", price))"
    }


    return (
      prePriceText.trimmingCharacters(in: .whitespacesAndNewlines),
      priceText.trimmingCharacters(in: .whitespacesAndNewlines),
      postPriceText.trimmingCharacters(in: .whitespacesAndNewlines),
      wasPriceText.trimmingCharacters(in: .whitespacesAndNewlines)
    )
  }
}
