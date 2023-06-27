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
  
  func translate(text: String, targetLanguage: String) -> Observable<Result<TranslationResult, Error>> {
    return self.repository.tranlsate(sourceText: text, to: targetLanguage)
  }
  
}
