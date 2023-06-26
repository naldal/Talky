//
//  AudioRecognizerError.swift
//  AudioRecognizer
//
//  Created by 송하민 on 2023/06/26.
//

import Foundation

public class AudioRecognizerError: Error {
  
  
  // MARK: - error type
  
  enum ErrorType {
    case recognitionTaskError
    case audioSessionError
    case tapInstallFailed
    case startFailed
    case selfIsNil
    
    var errorDescription: String {
      switch self {
        case .recognitionTaskError:
          return "음성인식에 문제가 발생했습니다."
        case .audioSessionError:
          return "오디오 세션을 시작하는데 문제가 발생했습니다."
        case .tapInstallFailed:
          return "음성인식을 텍스트로 변환하는데 문제가 발생했습니다."
        case .startFailed:
          return "녹음 시작에 오류가 발생했습니다."
        case .selfIsNil:
          return "self is nil"
      }
    }
  }
  
  // MARK: - internal properties
  
  var errorType: ErrorType?
  var description: String?
  
  
  // MARK: - life cycle
  
  init(_ type: ErrorType) {
    self.errorType = type
    self.description = type.errorDescription
  }
  
}
