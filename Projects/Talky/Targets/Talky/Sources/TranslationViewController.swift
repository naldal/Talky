//
//  TranslationViewController.swift
//  Talky
//
//  Created by 송하민 on 2023/06/24.
//

import UIKit
import SnapKit
import Then
import TalkyAssets

class TranslationViewController: UIViewController {
  
  let testLabel = UILabel().then {
    $0.text = "this is the test"
  }
  
  let imageView = UIImageView().then {
    $0.contentMode = .scaleAspectFit
    $0.image = Images.asdf.image
  }
  
  override func viewDidLoad() {
    
    // test
    self.view.backgroundColor = Colors.defaultColor.color
    self.setup()
  }
  
  func setup() {
    
    self.testLabel.makeConstraints(baseView: self.view, constraints: { make in
      make.centerX.centerY.equalToSuperview()
    })
    
    self.imageView.makeConstraints(baseView: self.view) { make in
      make.top.equalTo(self.testLabel.snp.bottom)
      make.centerX.equalToSuperview()
    }
    
  }
}
  
