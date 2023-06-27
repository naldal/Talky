//
//  TalkyError.swift
//  Talky
//
//  Created by 송하민 on 2023/06/26.
//  Copyright © 2023 TeamTalky. All rights reserved.
//

import Foundation

public class TalkyError: Error {
  
  
  enum From {
    case server
    case own
  }
  
  // MARK: - error type
  
  enum ErrorType {
    case commonError
    
    var errorDescription: String {
      switch self {
        case .commonError:
          return "just error"
      }
    }
  }
  
  // MARK: - internal properties
  
  var errorFrom: From?
  var errorType: ErrorType?
  var description: String?
  
  
  // MARK: - life cycle
  
  init(_ type: ErrorType) {
    self.errorType = type
    self.description = type.errorDescription
  }
  
  init(errorFrom: From, description: String?) {
    self.errorFrom = errorFrom
    self.description = description
  }
  
}
