//
//  Identifiable.swift
//  TalkyUIDev
//
//  Created by 송하민 on 2023/07/07.
//  Copyright © 2023 TeamTalky. All rights reserved.
//

import Foundation

protocol Identifiable { }

extension Identifiable {
  static func className() -> String {
    return String(describing: self)
  }
}
