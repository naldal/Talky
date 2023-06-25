//
//  ListenerView.swift
//  Talky
//
//  Created by 송하민 on 2023/06/25.
//  Copyright © 2023 organizationName. All rights reserved.
//

import UIKit
import TalkyAssets

final class ListerView: UIView {
  
  // MARK: - components
  
  private let baseView = UIView().then {
    $0.backgroundColor = .clear
  }
  
  // MARK: - internal properties
  
  var baseColor: UIColor? {
    didSet {
      self.setBaseViewColor(color: baseColor)
    }
  }
  
  // MARK: - life cycle
  
  init() {
    super.init(frame: .zero)
    self.layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - layout
  
  private func layout() {
    self.baseView.makeConstraints(baseView: self) { make in
      make.edges.equalToSuperview()
    }
  }
  
  // MARK: - private method
  
  private func setBaseViewColor(color: UIColor?) {
    self.baseView.backgroundColor = color ?? Colors.white.color
  }
}
