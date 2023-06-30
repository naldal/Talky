//
//  UIImage+Extension.swift
//  TalkyAssets
//
//  Created by 송하민 on 2023/06/29.
//

import UIKit

extension UIImageView {
  
  public func downLoadIamge(url: URL, effects: [ImageEffect]) {
    let imageLoader: ImageLoadAdapter = ImageLoadAdaptee()
    imageLoader.loadImageDefault(
      with: url,
      onto: self,
      placeholder: nil,
      priority: .lowPriority,
      effects: effects
    )
  }
}
