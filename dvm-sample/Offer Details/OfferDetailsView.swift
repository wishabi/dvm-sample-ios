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

            if let price = viewModel.price {
              VStack(alignment: .leading) {
                HStack(spacing: 4) {
                  Text(price)
                    .bold()
                    .font(.title2)
                    .foregroundStyle(.red)

                  if let postPrice = viewModel.postPrice {
                    Text(postPrice)
                  }
                }

                if let saleStory = viewModel.saleStory, !saleStory.isEmpty {
                  Text(saleStory)
                }
              }
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
        price: "Price",
        postPrice: "Post price",
        validity: "Valid from a - b",
        name: "Name",
        saleStory: "Sale story",
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
  let price: String?
  let postPrice: String?
  let validity: String
  let name: String?
  let saleStory: String?
  let description: String?
  let sku: String
  let disclaimer: String?

  init(imageURLStrings: [String],
       price: String?,
       postPrice: String?,
       validity: String,
       name: String?,
       saleStory: String?,
       description: String?,
       sku: String,
       disclaimer: String?) {
    self.imageURLStrings = imageURLStrings
    self.price = price
    self.postPrice = postPrice
    self.validity = validity
    self.name = name
    self.saleStory = saleStory?.isEmpty == false ? saleStory : nil
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

    var priceString = ""

    if let prePrice = offer.offerDetails?.prePriceText, !prePrice.isEmpty {
      priceString.append(prePrice)
      priceString.append(" ")
    }

    if let price = offer.pricing?.salePrice {
      priceString.append("$\(price)")
    } else if let price = offer.pricing?.price {
      priceString.append("$\(price)")
    }

    var imageURLStrings = [String]()

    if let imageURL = offer.details?.imageURL {
      imageURLStrings.append(imageURL)
    }

    if let additionalImages = offer.details?.additionalMedia.map({ $0.url }) {
      imageURLStrings.append(contentsOf: additionalImages)
    }

    self.init(
      imageURLStrings: imageURLStrings,
      price: priceString.isEmpty == false ? priceString : nil,
      postPrice: offer.offerDetails?.postPriceText,
      validity: validity,
      name: offer.details?.name,
      saleStory: offer.offerDetails?.saleStory,
      description: offer.details?.description,
      sku: "SKU: \(offer.details?.additionalInfo?.sku ?? "")",
      disclaimer: offer.offerDetails?.disclaimer)
  }
}
