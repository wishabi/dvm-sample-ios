//
//  BorderedTextField.swift
//  dvm-sample
//
//  Created by Matías Crespillo on 01/08/2024.
//

import UIKit

public class BorderedTextField: UITextField {
  private(set) var selectedBorderColor = UIColor.primary3
  private(set) var deselectedBorderColor = UIColor.default2

  public override var isSelected: Bool {
    didSet {
      if isSelected != oldValue {
        layer.borderColor = isSelected ?
        selectedBorderColor.cgColor :
        deselectedBorderColor.cgColor
      }
    }
  }
  override public func layoutSubviews() {
    super.layoutSubviews()

    changeBorderWithSelectedState()
  }

  private func changeBorderWithSelectedState() {
    let borderColorSelected = isSelected ? selectedBorderColor : deselectedBorderColor
    layer.borderColor = borderColorSelected.cgColor
  }

  init() {
    super.init(frame: .zero)
    textColor = UIColor.default5
    backgroundColor = UIColor.default1
    layer.cornerRadius = .extraExtraSmall
    layer.borderWidth = 1
  }
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public override func textRect(forBounds bounds: CGRect) -> CGRect {
    let padding = UIEdgeInsets(
      top: .extraExtraSmall,
      left: .medium,
      bottom: .extraExtraSmall,
      right: .medium
    )
    return bounds.inset(by: padding)
  }

  
}
