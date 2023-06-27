//
//  TalkyErrorExtension.swift
//  Talky
//
//  Created by Russell Hamin Song on 2023/06/27.
//  Copyright © 2023 TeamTalky. All rights reserved.
//

import Foundation
import AudioRecognizer

extension TalkyError {
  
  func toTalkyError(_ error: AudioRecognizerError) -> TalkyError {
    return .init(errorFrom: .server, description: error.description)
  }
}
