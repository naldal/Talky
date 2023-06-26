//
//  AudioListener.swift
//  AudioRecognizer
//
//  Created by 송하민 on 2023/06/26.
//

import Foundation

public final class AudioListener {
  
  public enum AudioListenerType {
    case willListening
    case listening
    case willStopping
    case stopped
  }
  
  // MARK: - public properties
  

  // MARK: - private properties
  
  private(set) var audioListerState: AudioListenerType = .stopped
  
  
  // MARK: - life cycle
  
  init() {
    
  }
  
  
  // MARK: - public method
  
  public func startListen() {
    
  }
  
  public func stopListen() {
    
  }
  
  // MARK: - private method
  
}
