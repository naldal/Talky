//
//  AudioListener.swift
//  AudioRecognizer
//
//  Created by 송하민 on 2023/06/26.
//

import Foundation
import RxSwift

public final class AudioListener {
  
  public enum AudioListenerType {
    case willListening
    case listening
    case willStopping
    case stopped
  }
  
  // MARK: - public properties
  

  // MARK: - private properties
  
  private let recognizationManger = AudioRecognizerManager.shared
  private(set) var audioListerState: AudioListenerType = .stopped
  
  
  // MARK: - life cycle
  
  public init() {
    
  }
  
  
  // MARK: - public method
  
  public func startListen() {
    return self.recognizationManger.startRecording()
  }
  
  public func stopListen() {
    
  }
  
  // MARK: - private method
  
}
