//
//  Error+Extensions.swift
//  Talky
//
//  Created by 송하민 on 2023/06/27.
//  Copyright © 2023 TeamTalky. All rights reserved.
//

import Foundation

extension Error {
  
  func toTalkyError() -> TalkyError {
    return TalkyError(errorFrom: .server, description: self.localizedDescription)
  }
}
