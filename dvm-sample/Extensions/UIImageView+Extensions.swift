//
//  UIImageView+Extensions.swift
//  dvm-sample
//
//  Created by William Chang on 2024-08-29.
//

import UIKit

extension UIImageView {
  // Very rudimentary implementation
  func loadImage(from url: URL, placeholder: UIImage? = nil) {
    let task = URLSession.shared.dataTask(with: url) { data, response, error in
      if let data = data, error == nil, let image = UIImage(data: data) {
        DispatchQueue.main.async {
          self.image = image.withRenderingMode(.alwaysOriginal)
        }
      }
    }
    task.resume()
  }
}
