//
//  UIFont+Extensions.swift
//  Talky
//
//  Created by 송하민 on 2023/06/24.
//  Copyright © 2023 organizationName. All rights reserved.
//

import UIKit

public typealias JetBrainsFont = TalkyAssetsFontFamily.JetBrainsMono

extension UIFont {

  public static var jetbrain13M: UIFont {
    return JetBrainsFont.medium.font(size: 13)
  }
  
  public static var jetbrain14: UIFont {
    return JetBrainsFont.medium.font(size: 14)
  }
  
  public static var jetbrain15: UIFont {
    return JetBrainsFont.medium.font(size: 15)
  }
  
  public static var jetbrain13R: UIFont {
    return JetBrainsFont.regular.font(size: 13)
  }
  
  public static var jetbrain14R: UIFont {
    return JetBrainsFont.regular.font(size: 14)
  }
  
  public static var jetbrain15R: UIFont {
    return JetBrainsFont.regular.font(size: 15)
  }
  
  public static var jetbrain13B: UIFont {
    return JetBrainsFont.bold.font(size: 13)
  }
  
  public static var jetbrain14B: UIFont {
    return JetBrainsFont.bold.font(size: 14)
  }
  
  public static var jetbrain15B: UIFont {
    return JetBrainsFont.bold.font(size: 15)
  }
  
}
