//
//  UIFont+Extensions.swift
//  Talky
//
//  Created by 송하민 on 2023/06/24.
//  Copyright © 2023 organizationName. All rights reserved.
//

import UIKit

public typealias NanumSquareRound = TalkyAssetsFontFamily.NanumSquareRoundOTF

public enum NanumSquareRoundType {
  case regular
  case bold
  case extrabold
}

extension UIFont {
  
  public static func font(fonts: NanumSquareRoundType, fontSize: CGFloat) -> UIFont {
    switch fonts {
    case .regular:
        return NanumSquareRound.regular.font(size: fontSize)
    case .bold:
        return NanumSquareRound.bold.font(size: fontSize)
      case .extrabold:
        return NanumSquareRound.extraBold.font(size: fontSize)
    }
  }
}
