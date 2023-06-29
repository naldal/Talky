//
//  ImageLoadAdapter.swift
//  TalkyAssets
//
//  Created by 송하민 on 2023/06/29.
//

import UIKit

enum ThreadPriority {
  case lowPriority
  case normalPriority
  case highPriority
}

public enum ImageEffect: Equatable {
  case gaussianBlur(radius: CGFloat)
  case cornerRadii(radii: CGFloat)
  case circle(borderColor: UIColor, borderWidth: CGFloat)
  case resize(width: CGFloat, height: CGFloat)
  case fadeIn(duration: CGFloat)
}

protocol ImageLoadAdapter {
  func loadImageDefault(
    with: URL?,
    onto: UIImageView?,
    placeholder: UIImage?,
    priority: ThreadPriority,
    effects: [ImageEffect]
  )
}

extension ImageLoadAdapter {
  func loadImageDefault(
    with: URL?,
    onto: UIImageView?,
    placeholder: UIImage? = nil,
    priority: ThreadPriority = .lowPriority,
    effects: [ImageEffect] = []
  ) {
    self.loadImageDefault(
      with: with,
      onto: onto,
      placeholder: placeholder,
      priority: priority,
      effects: effects
    )
  }
}

final class ImageLoadAdaptee: ImageLoadAdapter {

  private var adapter: ImageLoadAdapter?
  
  init() {
    self.adapter = NukeManager.shared
  }
  
  func loadImageDefault(
    with: URL?,
    onto: UIImageView?,
    placeholder: UIImage?,
    priority: ThreadPriority,
    effects: [ImageEffect]
  ) {
    self.adapter?.loadImageDefault(
      with: with,
      onto: onto,
      placeholder: placeholder,
      priority: priority,
      effects: effects
    )
  }
  
}
