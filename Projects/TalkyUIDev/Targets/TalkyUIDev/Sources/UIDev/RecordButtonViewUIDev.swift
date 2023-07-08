//
//  RecordButtonViewUIDev.swift
//  TalkyUIDev
//
//  Created by 송하민 on 2023/07/07.
//  Copyright © 2023 TeamTalky. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class RecordButtonViewUIDev: UIDevelopable {
  static func devViewController() -> UIViewController {
    return RecordButtonViewUIDevViewController(nibName: nil, bundle: nil)
  }
}

class RecordButtonViewUIDevViewController: UIViewController {
  
  // MARK: - component
  
  private let backgroundView = UIView().then {
    $0.backgroundColor = .white
  }
  
  private let recordButton1 = RecordButtonView().then {
    $0.state = .end
  }
  
  private let recordButton2 = RecordButtonView().then {
    $0.state = .start
  }
  
  private lazy var recordButtonStack = UIStackView().then {
    $0.axis = .vertical
    $0.spacing = 20
    $0.addArrangedSubview(recordButton1)
    $0.addArrangedSubview(recordButton2)
  }

  
  // MARK: - private properties
  
  private let disposeBag = DisposeBag()
  
  
  // MARK: - life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
    self.bind()
  }
  
  // MARK: - setup
  
  private func setup() {
    self.backgroundView.makeConstraints(baseView: self.view) { make in
      make.edges.equalToSuperview()
    }
    
    self.recordButton1.snp.makeConstraints { make in
      make.height.equalTo(60)
    }
    
    self.recordButton2.snp.makeConstraints { make in
      make.height.equalTo(60)
    }
    
    self.recordButtonStack.makeConstraints(baseView: self.view) { make in
      make.centerX.centerY.equalToSuperview()
      make.width.equalToSuperview().inset(40)
    }
  }
  
  
  // MARK: - bind
  
  private func bind() {
    self.recordButton1.rx.didTap
      .asDriver(onErrorJustReturn: ())
      .drive(onNext: {
        print("button1 tapped")
      })
      .disposed(by: self.disposeBag)
    
    self.recordButton2.rx.didTap
      .asDriver(onErrorJustReturn: ())
      .drive(onNext: {
        print("button2 tapped")
      })
      .disposed(by: self.disposeBag)
  }
  
  
}
