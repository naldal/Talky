//
//  TranslateAPI.swift
//  Talky
//
//  Created by 송하민 on 2023/06/25.
//  Copyright © 2023 TeamTalky. All rights reserved.
//

import Foundation
import Moya

enum TranslateAPI {
  case translate(apiKey: String, sourceText: String, targetLanguage: Locale?)
}

extension TranslateAPI: TargetType {
  
  var baseURL: URL {
    return URL(string: "https://translation.googleapis.com/")!
  }
  
  var path: String {
    switch self {
      case .translate:
        return "language/translate/v2"
    }
  }
  
  var method: Moya.Method {
    switch self {
      case .translate:
        return .post
    }
  }
  
  var task: Moya.Task {
    switch self {
      case .translate(let apiKey, let sourceText, let targetLanguage):
        let bodyParams: [String: Any] = {
          var returnBodyParams: [String: Any] = [:]
          returnBodyParams["q"] = sourceText
          if let translationLanguage = (targetLanguage as? NSLocale)?.object(forKey: .languageCode) {
            returnBodyParams["target"] = translationLanguage
          } else {
            returnBodyParams["target"] = "en"
          }
          returnBodyParams["format"] = "text"
          return returnBodyParams
        }()
        let apiKeyParam: [String: String] = ["key": apiKey]
        return .requestCompositeParameters(
          bodyParameters: bodyParams,
          bodyEncoding: JSONEncoding.default,
          urlParameters: apiKeyParam
        )
    }
  }
  
  var headers: [String : String]? {
    return ["Content-type": "application/json"]
  }
  
  
}
