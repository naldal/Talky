//
//  UIFont+Extensions.swift
//  Talky
//
//  Created by 송하민 on 2023/06/24.
//  Copyright © 2023 organizationName. All rights reserved.
//

import UIKit

public typealias NanumSquareRound = TalkyAssetsFontFamily.NanumSquareRoundOTF
public typealias NanumSquareSquare = TalkyAssetsFontFamily.NanumSquareNeoOTF

public enum NanumSquareType {
  case regular
  case bold
  case extrabold
}

extension UIFont {
  
  public static func font(fonts: NanumSquareType, fontSize: CGFloat) -> UIFont {
    switch fonts {
    case .regular:
        return NanumSquareSquare.regular.font(size: fontSize)
    case .bold:
        return NanumSquareSquare.bold.font(size: fontSize)
      case .extrabold:
        return NanumSquareSquare.extraBold.font(size: fontSize)
    }
  }
}
