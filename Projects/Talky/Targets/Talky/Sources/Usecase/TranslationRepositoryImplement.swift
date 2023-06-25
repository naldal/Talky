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
  
  private let translateAPI = NetworkProvider<TranslateAPI>()
  
  
  // MARK: - internal properties
  
  func tranlsate(sourceText: String, to: String) -> Observable<Result<TranslationResult, Error>> {
    return self.translateAPI.request(target: .translate(apiKey: TalkyInfo.googleClientAPI, sourceText: sourceText, targetLanguage: to))
      .map { result in
        switch result {
          case .success(let data):
            let jsonData = JSON(data)
            guard let translations = jsonData["data"]["translations"].array,
                  let translationData = try? translations.first?.rawData(),
                  let translationResult = try? JSONDecoder().decode(TranslationResult.self, from: translationData) else { fatalError("AA") }
            return .success(translationResult)
          case .failure(let error):
            return .failure(error)
        }
      }
    
  }
  
  
}
