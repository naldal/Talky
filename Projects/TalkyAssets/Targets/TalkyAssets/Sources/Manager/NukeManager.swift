//
//  NukeManager.swift
//  TalkyAssets
//
//  Created by 송하민 on 2023/06/29.
//

import UIKit
import Nuke
import NukeExtensions
import NukeUI

enum CacheStrategy {
  case MemoryCache
  case HTTPDiskCache
  case AggressiveDiskCache
}

final class NukeManager {
  
  
  // MARK: - internal properites
  
  var imagePrefetcher: ImagePrefetcher {
    ImagePrefetcher(pipeline: self.pipeline, destination: .diskCache)
  }
  
  
  // MARK: - private properties
  
  private var pipeline = ImagePipeline.shared
  
  
  // MARK: - static properties
  
  static let shared = NukeManager(cacheStragies: [.MemoryCache, .AggressiveDiskCache])
  
  
  
  // MARK: - life cycle
  
  init(
    isDecompressionEnabled: Bool = true,
    isTaskCoalescingEnabled: Bool = true,
    isResumableDataEnabled: Bool = true,
    isRateLimiterEnabled: Bool = true,
    isProgressiveDecodingEnabled: Bool = true,
    cacheStragies: [CacheStrategy]) {
      
      var configuration = ImagePipeline.shared.configuration
      
      configuration.isDecompressionEnabled = isDecompressionEnabled
      configuration.isTaskCoalescingEnabled = isTaskCoalescingEnabled
      configuration.isResumableDataEnabled = isResumableDataEnabled
      configuration.isRateLimiterEnabled = isRateLimiterEnabled
      
      configuration.isProgressiveDecodingEnabled = isProgressiveDecodingEnabled
      configuration.isStoringPreviewsInMemoryCache = isProgressiveDecodingEnabled
      
      guard !cacheStragies.isEmpty else { return }
      
      configuration.imageCache = cacheStragies.contains(.MemoryCache) ? ImageCache.shared : nil
      
      let dataLoadConfiguration = DataLoader.defaultConfiguration
      dataLoadConfiguration.urlCache = cacheStragies.contains(.HTTPDiskCache) ? DataLoader.sharedUrlCache : nil
      configuration.dataLoader = DataLoader(configuration: dataLoadConfiguration)
      
      configuration.dataCache = cacheStragies.contains(.AggressiveDiskCache) ? try? DataCache(name: "wemade.Nuke.DataCache") : nil
      
      self.pipeline = ImagePipeline(configuration: configuration)
      
  }
  private init() {}
  
  
  // MARK: - private functions
  
  @MainActor private func loadImage(
    with url: URL?,
    requestOptions: [ImageProcessing] = [],
    priority: ImageRequest.Priority = .low,
    placeholder: UIImage? = nil,
    transition: ImageLoadingOptions.Transition? = nil,
    onto targetImageView: UIImageView?
  ) {
    guard let targetImageView = targetImageView else {
      print("target ImageView is nil")
      return
    }
    let imageViewIdentifier = targetImageView.accessibilityIdentifier
    
    let imageRequest = ImageRequest(
      url: url,
      processors: requestOptions,
      priority: priority
    )
    var loadingOptions = ImageLoadingOptions(
      placeholder: placeholder,
      transition: transition
    )
    loadingOptions.pipeline = pipeline
    NukeExtensions.loadImage(
      with: imageRequest,
      options: loadingOptions,
      into: targetImageView) { result in
        switch result {
        case .success(_):
          break
        case .failure(let failure):
          if let imageViewIdentifier {
            print("ImageView that has \(imageViewIdentifier) occured an error: \(failure)")
          } else {
            print("ambiguous ImageView occured an error: \(failure)")
          }
        }
      }
  }
}

extension NukeManager: ImageLoadAdapter {
  
  @MainActor func loadImageDefault(
    with url: URL?,
    onto target: UIImageView?,
    placeholder: UIImage? = nil,
    priority: ThreadPriority = .lowPriority,
    effects: [ImageEffect] = []
  ) {
    var imageRequestPriority: ImageRequest.Priority = .normal
    switch priority {
    case .lowPriority:
      imageRequestPriority = .low
    case .normalPriority:
      imageRequestPriority = .normal
    case .highPriority:
      imageRequestPriority = .high
    }
    
    var requestOptions: [ImageProcessing] = []
    var fadeInTransition: ImageLoadingOptions.Transition?
    
    effects.forEach({ effect in
      switch effect {
      case .gaussianBlur(let radius):
        requestOptions.append(ImageProcessors.GaussianBlur(radius: Int(radius)))
      case .cornerRadii(let radii):
        requestOptions.append(ImageProcessors.RoundedCorners(radius: radii))
      case .circle(let borderColor, let borderWidth):
        requestOptions.append(ImageProcessors.Circle(border: ImageProcessingOptions.Border(color: borderColor, width: borderWidth)))
      case .resize(let width, let height):
        requestOptions.append(ImageProcessors.Resize(size: CGSize(width: width, height: height)))
      case .fadeIn(let duration):
        fadeInTransition = ImageLoadingOptions.Transition.fadeIn(duration: duration)
      }
    })
    self.loadImage(
      with: url,
      requestOptions: requestOptions,
      priority: imageRequestPriority,
      placeholder: placeholder,
      transition: fadeInTransition,
      onto: target
    )
  }
  
}
