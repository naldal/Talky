//
//  MainReactor.swift
//  Talky
//
//  Created by 송하민 on 2023/06/25.
//  Copyright © 2023 organizationName. All rights reserved.
//

import UIKit
import ReactorKit
import Speech

final class MainReactor: Reactor {
  
  enum Action {
    case initialSetting
    case exchangeLocales
    case tappedRecord
    case selectvoiceRecognitionLanguage(Locale)
    case selecttranslationTargetLanguage(Locale)
    case voiceInput(String)
  }
  
  enum Mutate {
    case empty
    case setError(TalkyError?)
    case setRecognitionState(SFSpeechRecognitionTaskState?)
    case setVoiceConvertedText(String?)
    case setVoiceRecognitionLanguage(Locale)
    case setTranslationTargetLanguage(Locale)
    case setTranslatedText(String)
  }
  
  struct State {
    var error: TalkyError? = nil
    var recognitionState: Pulse<SFSpeechRecognitionTaskState?> = .init(wrappedValue: nil)
    var voiceConvertedText: Pulse<String?> = .init(wrappedValue: nil)
    var voiceRecognitionLanguage: Pulse<Locale> = .init(wrappedValue: Locale.current)
    var translationTargetLanguage: Pulse<Locale> = .init(wrappedValue: Locale.init(identifier: "en-US"))
    var translatedText: Pulse<String> = .init(wrappedValue: "")
  }
  
  // MARK: - private properties
  
  private let usecase: TranslationUsecase
  
  // MARK: - internal properties
  
  let initialState: State = .init()
  
  
  // MARK: - life cycle
  
  init(usecase: TranslationUsecase) {
    self.usecase = usecase
  }
  
  func mutate(action: Action) -> Observable<Mutate> {
    
    switch action {
        
      case .initialSetting:
        let initialTranslateLocale = self.currentState.translationTargetLanguage.value
        let initialRecognitionLocale = self.currentState.voiceRecognitionLanguage.value
        
        return Observable.from([
          self.setTranslationLocale(locale: initialTranslateLocale),
          self.setVoiceRecognitionLocale(locale: initialRecognitionLocale)
        ]).map { _ in
          return .empty
        }
        
      case .exchangeLocales:
        guard self.currentState.recognitionState.value != .running else {
          return .empty()
        }
        let currentTranslateLocale = self.currentState.translationTargetLanguage.value
        let currentRecognitionLocale = self.currentState.voiceRecognitionLanguage.value
        
        return Observable.from([
          self.setTranslationLocale(locale: currentRecognitionLocale),
          self.setVoiceRecognitionLocale(locale: currentTranslateLocale)
        ]).flatMap { _ -> Observable<Mutate> in
          return .from([
            .setTranslationTargetLanguage(currentRecognitionLocale),
            .setVoiceRecognitionLanguage(currentTranslateLocale)
          ])
        }
        
      case .tappedRecord:
        let currentState = self.currentState.recognitionState.value
        if currentState == .running {
          self.stopAudioRecognizer()
        }
        if currentState == nil || currentState == .completed {
          self.startAudioRecognizer()
        }
        let stateMutation = self.listenRecognizerState().map {
          return Mutate.setRecognitionState($0)
        }
        let textMutation = self.listenConvertedText().map { text in
          return Mutate.setVoiceConvertedText(text)
        }
        return Observable.merge(stateMutation, textMutation)
        
      case .selectvoiceRecognitionLanguage(let foreignLang):
        return .just(.setVoiceRecognitionLanguage(foreignLang))
        
      case .selecttranslationTargetLanguage(let motherlandLang):
        return .just(.setTranslationTargetLanguage(motherlandLang))
        
      case .voiceInput(let voice):
        return self.translate(voiceText: voice)
          .map({ [weak self] result in
            switch result {
              case .success(let translateResult):
                let currentRecordState = self?.currentState.recognitionState.value
                guard currentRecordState == .running else {
                  return .empty
                }
                return .setTranslatedText(translateResult.translatedText)
              case .failure(let error):
                print(error)
                return .empty
            }
          })
    }
  }
  
  func reduce(state: State, mutation: Mutate) -> State {
    var newState = state
    switch mutation {
      case .empty:
        break
      case .setError(let talkyError):
        newState.error = talkyError
      case .setRecognitionState(let state):
        newState.recognitionState.value = state
      case .setVoiceRecognitionLanguage(let voiceRecognitionLanguage):
        newState.voiceRecognitionLanguage.value = voiceRecognitionLanguage
      case .setTranslationTargetLanguage(let translationTargetLanguage):
        newState.translationTargetLanguage.value = translationTargetLanguage
      case .setTranslatedText(let translatedText):
        newState.translatedText.value = translatedText
      case .setVoiceConvertedText(let convertedText):
        newState.voiceConvertedText.value = convertedText
    }
    return newState
  }
  
  // MARK: - private func
  
  
  // handle recognizer
  
  private func startAudioRecognizer() {
    return usecase.startAudioRecognizer()
  }
  
  private func stopAudioRecognizer() {
    return usecase.stopAudioRecognizer()
  }
  
  // recognizer states
  
  private func listenRecognizerState() -> Observable<SFSpeechRecognitionTaskState?> {
    return usecase.listenRecognizerState()
  }
  
  private func listenConvertedText() -> Observable<String?> {
    return usecase.listenConvertedText()
  }
  
  // locales
  
  private func setVoiceRecognitionLocale(locale: Locale) -> Observable<Void> {
    return usecase.setVoiceRecognitionLocale(locale: locale)
  }
  
  private func setTranslationLocale(locale: Locale) -> Observable<Void> {
    return usecase.setTranslationLocale(locale: locale)
  }
  
  
  // translate
  
  private func translate(voiceText: String) -> Observable<Result<TranslationResult, TalkyError>> {
    return usecase.translate(text: voiceText)
  }
  
}
