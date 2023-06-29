//
//  UIImage+Extension.swift
//  TalkyAssets
//
//  Created by 송하민 on 2023/06/29.
//

import UIKit

extension UIImage {
  
  public func downLoadIamge(url: URL, imageView: UIImageView, effects: [ImageEffect]) {
    let imageLoader: ImageLoadAdapter = ImageLoadAdaptee()
    imageLoader.loadImageDefault(
      with: url,
      onto: imageView,
      placeholder: nil,
      priority: .lowPriority,
      effects: effects
    )
  }
}
