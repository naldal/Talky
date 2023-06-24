//
//  UIView+Extensions.swift
//  Talky
//
//  Created by 송하민 on 2023/06/24.
//  Copyright © 2023 organizationName. All rights reserved.
//

import UIKit
import SnapKit

extension UIView {
  
  func makeConstraints(baseView: UIView, constraints: (_ make: ConstraintMaker) -> Void) {
    baseView.addSubview(self)
    self.snp.makeConstraints(constraints)
  }
  
  func remakeConstraints(baseView: UIView, constraints: (_ make: ConstraintMaker) -> Void) {
    baseView.addSubview(self)
    self.snp.remakeConstraints(constraints)
  }
  
}


