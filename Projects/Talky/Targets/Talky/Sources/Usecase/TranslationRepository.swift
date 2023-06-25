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
  // TODO: replece String to Language Type (maybe enum or whatever)
  func tranlsate(sourceText: String, to: String) -> Observable<Result<TranslationResult, Error>>
}

struct TranslationResult: Decodable {
  let translatedText: String
  let detectedSourceLanguage: String
}
