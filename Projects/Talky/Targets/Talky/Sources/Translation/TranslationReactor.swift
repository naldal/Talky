//
//  TranslationReactor.swift
//  Talky
//
//  Created by 송하민 on 2023/06/25.
//  Copyright © 2023 organizationName. All rights reserved.
//

import UIKit
import ReactorKit

final class TranslationReactor: Reactor {
  
  enum Action {
    case startRecord
    case stopRecord
    case selectForeignLanguage(String)
    case selectMotherLandLanguage(String)
    case voiceInput(String)
  }
  
  enum Mutate {
    case empty
    case setIsRecord(Bool)
    case setForeignLanguage(String)
    case setMotherLandLanguage(String)
    case setTranslatedText(String)
  }
  
  struct State {
    var isRecord: Pulse<Bool> = .init(wrappedValue: false)
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
      case .startRecord:
        return .just(.setIsRecord(true))
      case .stopRecord:
        return .just(.setIsRecord(false))
      case .selectForeignLanguage(let foreignLang):
        return .just(.setForeignLanguage(foreignLang))
      case .selectMotherLandLanguage(let motherlandLang):
        return .just(.setMotherLandLanguage(motherlandLang))
      case .voiceInput(let voice):
        // TODO: remove "en" but make set the target language later
        return self.translate(voiceText: voice, targetLanguage: "en")
          .map({ result in
            switch result {
              case .success(let translateResult):
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
      case .setIsRecord(let isRecord):
        newState.isRecord.value = isRecord
      case .setForeignLanguage(let foreignLanguage):
        newState.foreignLanguage.value = foreignLanguage
      case .setMotherLandLanguage(let motherlandLanguage):
        newState.motherlandLanguage.value = motherlandLanguage
      case .setTranslatedText(let translatedText):
        newState.translatedText.value = translatedText
    }
    return newState
  }
  
  // MARK: - private func
  
  private func translate(voiceText: String, targetLanguage: String) -> Observable<Result<TranslationResult, Error>> {
    return usecase.translate(text: voiceText, targetLanguage: targetLanguage)
  }
  
}
