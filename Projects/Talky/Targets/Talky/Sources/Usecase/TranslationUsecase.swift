//
//  TranslationUsecase.swift
//  Talky
//
//  Created by 송하민 on 2023/06/25.
//  Copyright © 2023 TeamTalky. All rights reserved.
//

import Foundation
import RxSwift
import AudioRecognizer
import Speech

final class TranslationUsecase {
  
  // MARK: - private properties
  
  private let repository: TranslationRepository
  private let audioListenser: AudioListener = AudioListener()
  
  
  // MARK: - life cycle
  
  init(repository: TranslationRepository) {
    self.repository = repository
  }
  
  
  // MARK: - internal method

  func startAudioRecognizer() {
    return self.audioListenser.startListen()
  }
  
  func stopAudioRecognizer() {
    return self.audioListenser.stopListen()
  }
  
  func listenRecognizerState() -> Observable<SFSpeechRecognitionTaskState?> {
    return self.audioListenser.stateObservable
  }
  
  func listenConvertedText() -> Observable<String?> {
    return self.audioListenser.convertedTextObservable
  }
  
  
  func translate(text: String, targetLanguage: String) -> Observable<Result<TranslationResult, TalkyError>> {
    return self.repository.tranlsate(sourceText: text, to: targetLanguage)
  }
  
}
