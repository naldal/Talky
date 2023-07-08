//
//  SampleTest.swift
//  Talky
//
//  Created by 송하민 on 2023/06/24.
//  Copyright © 2023 organizationName. All rights reserved.
//

import Quick
import Nimble
@testable import TalkyDev

final class SampleTest: QuickSpec {
  
  override func spec() {
    describe("Math") {
      it("should correctly calculate the sum of 1+1") {
        expect(1 + 1).to(equal(2))
      }
    }
  }
  
}
