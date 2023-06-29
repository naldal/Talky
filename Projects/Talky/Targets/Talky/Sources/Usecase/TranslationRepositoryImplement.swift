//
//  TranslationRepositoryImplement.swift
//  Talky
//
//  Created by 송하민 on 2023/06/25.
//  Copyright © 2023 TeamTalky. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SwiftyJSON

final class TranslationRepositoryImplement: TranslationRepository {
  
  // MARK: - private properties
  
  private var translateLocale: Locale?
  private let translateAPI = NetworkProvider<TranslateAPI>()
  
  
  // MARK: - internal properties
  
  func setTranslationLocale(locale: Locale) -> Observable<Void> {
    self.translateLocale = locale
    return .empty()
  }
  
  func tranlsate(sourceText: String) -> Observable<Result<TranslationResult, TalkyError>> {
    return self.translateAPI.request(target: .translate(apiKey: TalkyInfo.googleClientAPI, sourceText: sourceText, targetLanguage: self.translateLocale))
      .map { result in
        switch result {
          case .success(let data):
            let jsonData = JSON(data)
            guard let translations = jsonData["data"]["translations"].array,
                  let translationData = try? translations.first?.rawData(),
                  let translationResult = try? JSONDecoder().decode(TranslationResult.self, from: translationData) else {
              return .failure(TalkyError(.commonError))
            }
            return .success(translationResult)
          case .failure(let error):
            return .failure(error.toTalkyError())
        }
      }
    
  }
  
  
}
