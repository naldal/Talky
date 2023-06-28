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
    case tappedRecord
    case selectForeignLanguage(String)
    case selectMotherLandLanguage(String)
    case voiceInput(String)
  }
  
  enum Mutate {
    case empty
    case setError(TalkyError?)
    case setRecognitionState(SFSpeechRecognitionTaskState?)
    case setVoiceConvertedText(String?)
    case setForeignLanguage(String)
    case setMotherLandLanguage(String)
    case setTranslatedText(String)
  }
  
  struct State {
    var error: TalkyError? = nil
    var recognitionState: Pulse<SFSpeechRecognitionTaskState?> = .init(wrappedValue: nil)
    var voiceConvertedText: Pulse<String?> = .init(wrappedValue: nil)
    var foreignLanguage: Pulse<String> = .init(wrappedValue: "")
    var motherlandLanguage: Pulse<String> = .init(wrappedValue: "")
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
        
      case .selectForeignLanguage(let foreignLang):
        return .just(.setForeignLanguage(foreignLang))
        
      case .selectMotherLandLanguage(let motherlandLang):
        return .just(.setMotherLandLanguage(motherlandLang))
        
      case .voiceInput(let voice):
        // TODO: remove "en" but make set the target language later
        return self.translate(voiceText: voice, targetLanguage: "en")
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
      case .setForeignLanguage(let foreignLanguage):
        newState.foreignLanguage.value = foreignLanguage
      case .setMotherLandLanguage(let motherlandLanguage):
        newState.motherlandLanguage.value = motherlandLanguage
      case .setTranslatedText(let translatedText):
        newState.translatedText.value = translatedText
      case .setVoiceConvertedText(let convertedText):
        newState.voiceConvertedText.value = convertedText
    }
    return newState
  }
  
  // MARK: - private func
  
  private func startAudioRecognizer() {
    return usecase.startAudioRecognizer()
  }
  
  private func stopAudioRecognizer() {
    return usecase.stopAudioRecognizer()
  }
  
  private func listenRecognizerState() -> Observable<SFSpeechRecognitionTaskState?> {
    return usecase.listenRecognizerState()
  }
  
  private func listenConvertedText() -> Observable<String?> {
    return usecase.listenConvertedText()
  }
  
  private func translate(voiceText: String, targetLanguage: String) -> Observable<Result<TranslationResult, TalkyError>> {
    return usecase.translate(text: voiceText, targetLanguage: targetLanguage)
  }
  
}
