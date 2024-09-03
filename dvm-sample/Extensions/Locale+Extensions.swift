//
//  Locale+Extensions.swift
//  dvm-sample
//
//  Created by William Chang on 2024-08-27.
//

import Foundation

extension Locale {
  static func preferredLanguageCode() -> String? {
    guard let code = Locale.preferredLanguages.first?.prefix(2) else {
      return nil
    }

    return String(code)
  }
}
