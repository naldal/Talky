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

final class TranslationRepositoryImplement: TranslationRepository {
  
  // MARK: - private properties
  
  private let translateAPI = NetworkProvider<TranslateAPI>()
  
  
  // MARK: - internal properties
  
  func tranlsate(sourceText: String, to: String) -> Observable<Result<TranslationResult, Error>> {
    return .just(.success(TranslationResult(translatedText: "this is mocking result", detectedSourceLanguage: "en")))
  }
  
  
}
