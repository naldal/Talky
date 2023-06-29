//
//  TranslationRepository.swift
//  Talky
//
//  Created by 송하민 on 2023/06/25.
//  Copyright © 2023 TeamTalky. All rights reserved.
//

import Foundation
import RxSwift

protocol TranslationRepository {
  func setTranslationLocale(locale: Locale) -> Observable<Void>
  func tranlsate(sourceText: String) -> Observable<Result<TranslationResult, TalkyError>>
}

struct TranslationResult: Decodable {
  let translatedText: String
  let detectedSourceLanguage: String
}
