//
//  String+Extensions.swift
//  Talky
//
//  Created by 송하민 on 2023/06/25.
//  Copyright © 2023 TeamTalky. All rights reserved.
//

import UIKit

extension String {
  
  func textHeight(containerWidth: CGFloat, font: UIFont) -> CGFloat {
    let textAttributes = [NSAttributedString.Key.font : font]
    let boundingRect = self.boundingRect(
      with: CGSize(width: containerWidth, height: CGFloat.greatestFiniteMagnitude),
      options: [.usesLineFragmentOrigin, .usesFontLeading],
      attributes: textAttributes,
      context: nil
    )
    return boundingRect.height
  }
  
}
