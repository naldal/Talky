//
//  AudioListener.swift
//  AudioRecognizer
//
//  Created by 송하민 on 2023/06/26.
//

import Foundation
import RxSwift
import RxCocoa
import Speech

public final class AudioListener {
  
  public enum AudioListenerType {
    case willListening
    case listening
    case willStopping
    case stopped
  }
  
  // MARK: - public properties

  public let stateObservable: BehaviorSubject<SFSpeechRecognitionTaskState?> = .init(value: nil)
  public let convertedTextObservable: BehaviorSubject<String?> = .init(value: nil)
  
  
  // MARK: - private properties
  
  private let recognizationManger = AudioRecognizerManager.shared
  private(set) var audioListerState: AudioListenerType = .stopped
  
  
  // MARK: - life cycle
  
  public init() {
    self.listenState()
    self.listenConvertedText()
  }
  
  let disposeBag = DisposeBag()
  
  
  // MARK: - public method
  
  public func setRecognitionLocale(locale: Locale) -> Observable<Void> {
    self.recognizationManger.currentRecognizationLanguage = locale
    return .just(())
  }
  
  public func startListen() {
    return self.recognizationManger.startRecording()
  }
  
  public func stopListen() {
    return self.recognizationManger.stopRecording()
  }
   
  public func listenState() {
    self.recognizationManger.recognizeTaskStatus
      .bind(to: self.stateObservable)
      .disposed(by: self.disposeBag)
  }
  
  public func listenConvertedText() {
    self.recognizationManger.recognizedTextSubject
      .bind(to: self.convertedTextObservable)
      .disposed(by: self.disposeBag)
  }
  
  // MARK: - private method
  
}
