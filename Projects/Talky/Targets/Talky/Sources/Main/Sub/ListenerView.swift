//
//  ListenerView.swift
//  Talky
//
//  Created by 송하민 on 2023/06/25.
//  Copyright © 2023 organizationName. All rights reserved.
//

import UIKit
import Then
import TalkyAssets
import RxSwift
import RxCocoa

final class ListerView: UIView, UITextViewDelegate {
  
  // MARK: - components
  
  private let baseView = UIView().then {
    $0.layer.cornerRadius = 15
    $0.layer.borderColor = Colors.brown.color.cgColor
    $0.layer.borderWidth = 1.0
    $0.backgroundColor = Colors.white.color
  }
  
  private lazy var listeningTextView = UITextView().then {
    $0.textContainer.lineBreakMode = .byCharWrapping
    $0.textContainer.maximumNumberOfLines = 0
    $0.isScrollEnabled = true
    $0.textAlignment = .left
    $0.adjustsFontForContentSizeCategory = true
    $0.font = .font(fonts: .bold, fontSize: 38)
    $0.delegate = self
  }
  
  // MARK: - internal properties
 
  // MARK: - internal properties
  
  // MARK: - private properties
  
  private typealias FontSize = CGFloat
  private typealias TextContainerHeight = CGFloat
  private let disposeBag = DisposeBag()
  
  
  // MARK: - life cycle
  
  init() {
    super.init(frame: .zero)
    self.bind()
    self.layout()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - layout
  
  private func layout() {
    self.baseView.makeConstraints(baseView: self) { make in
      make.edges.equalToSuperview()
    }
    
    self.listeningTextView.makeConstraints(baseView: self.baseView) { make in
      make.leading.trailing.equalToSuperview()
      make.top.bottom.equalToSuperview().inset(20)
    }
  }
  
  // MARK: - bind
  
  private func bind() {
    self.listeningTextView.rx.text
      .asDriver()
      .drive(onNext: { [weak self] text in
        guard let textCount = text?.count,
              textCount >= 1 else { return }
        self?.listeningTextView.scrollRangeToVisible(NSRange(location: textCount - 1, length: 1))
      })
      .disposed(by: self.disposeBag)
  }
  
 
  // MARK: - internal method
  
  func setText(text: String?) {
    self.listeningTextView.text = text
  }
  
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    return false
  }

  
  // MARK: - private method
  
  
}
