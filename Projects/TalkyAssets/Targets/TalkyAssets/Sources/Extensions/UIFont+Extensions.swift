//
//  UIFont+Extensions.swift
//  Talky
//
//  Created by 송하민 on 2023/06/24.
//  Copyright © 2023 organizationName. All rights reserved.
//

import UIKit

public typealias JetBrainsFont = TalkyAssetsFontFamily.JetBrainsMono

public enum JetBrainMonoFontType {
  case medium
  case bold
}

extension UIFont {
  
  public static func font(fonts: JetBrainMonoFontType, fontSize: CGFloat) -> UIFont {
    switch fonts {
    case .medium:
        return JetBrainsFont.medium.font(size: fontSize)
    case .bold:
        return JetBrainsFont.bold.font(size: fontSize)
    }
  }
}
