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

final class ListerView: UIView {
  
  // MARK: - components
  
  private let baseView = UIView().then {
    $0.layer.masksToBounds = true
    $0.layer.cornerRadius = 20
    $0.layer.borderColor = Colors.secondary.color.cgColor
    $0.layer.borderWidth = 1.0
    $0.backgroundColor = .clear
  }
  
  private lazy var listeningTextView = UITextView().then {
    $0.textContainerInset = .init(top: 32, left: 24, bottom: 48, right: 24)
    $0.textContainer.lineBreakMode = .byCharWrapping
    $0.textContainer.maximumNumberOfLines = 0
    $0.isScrollEnabled = true
    $0.textAlignment = .left
    $0.adjustsFontForContentSizeCategory = true
    $0.delegate = self
  }
  
  private let languageLabel = UILabel().then {
    $0.font = UIFont.font(fonts: .regular, fontSize: 16)
    $0.textColor = .black
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
      make.edges.equalToSuperview()
    }
    
    self.languageLabel.makeConstraints(baseView: self.baseView) { make in
      make.bottom.trailing.equalToSuperview().inset(12)
    }
  }
  
  // MARK: - bind
  
  private func bind() {
    self.listeningTextView.rx.text
      .asDriver()
      .drive(onNext: { [weak self] text in
        guard let textCount = text?.count, textCount >= 1 else { return }
        self?.listeningTextView.scrollRangeToVisible(NSRange(location: textCount - 1, length: 1))
        guard let isTouched = self?.checkIsScrollTouchBottom(), isTouched else {
          self?.makeTouchScrollView()
          return
        }
      })
      .disposed(by: self.disposeBag)
  }
  
 
  // MARK: - internal method
  
  func setText(text: String?) {
    let paragraphStyle = NSMutableParagraphStyle()
    paragraphStyle.lineSpacing = 12
    let attributedString = NSAttributedString(
      string: text ?? "",
      attributes: [
        NSAttributedString.Key.paragraphStyle: paragraphStyle,
        NSAttributedString.Key.font: UIFont.font(fonts: .extrabold, fontSize: 26)
      ]
    )
    self.listeningTextView.textColor = .black
    self.listeningTextView.attributedText = attributedString
  }
  
  func clearTextView() {
    self.listeningTextView.text = ""
  }
  
  func setPlaceholder(text placeholder: String) {
    self.listeningTextView.textColor = .gray
    self.listeningTextView.font = .font(fonts: .bold, fontSize: 22)
    self.listeningTextView.text = placeholder
  }
  
  func setLanguage(lang: String) {
    self.languageLabel.text = lang
  }
  
  // MARK: - private method
  
  private func checkIsScrollTouchBottom() -> Bool {
    let bottomEdge = listeningTextView.contentOffset.y + listeningTextView.bounds.size.height
     return bottomEdge >= listeningTextView.contentSize.height
  }

  private func makeTouchScrollView() {
    let bottomOffset = CGPoint(x: 0, y: listeningTextView.contentSize.height - listeningTextView.bounds.size.height + listeningTextView.contentInset.bottom)
    self.listeningTextView.setContentOffset(bottomOffset, animated: true)
  }
}

extension ListerView: UITextViewDelegate {
  
  func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
    return false
  }
  
}
