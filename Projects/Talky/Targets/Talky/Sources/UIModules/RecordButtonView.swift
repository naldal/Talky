//
//  RecordButtonView.swift
//  Talky
//
//  Created by 송하민 on 2023/06/28.
//  Copyright © 2023 TeamTalky. All rights reserved.
//

import UIKit
import SnapKit
import Then
import Lottie
import TalkyAssets
import RxSwift
import RxCocoa

@objc protocol RecordButtonViewDelegate: AnyObject {
  @objc optional func tap(_ view: RecordButtonView)
}

final class RecordButtonView: UIView {
  
  enum RecoardState {
    case start
    case end
  }
  
  // MARK: - components
  
  private lazy var baseView = UIView().then {
    $0.layer.cornerRadius = 30
    $0.isUserInteractionEnabled = true
    let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapBase))
    $0.addGestureRecognizer(tapGesture)
    $0.backgroundColor = Colors.secondary.color
  }
  
  @objc private func tapBase() {
    self.delegate?.tap?(self)
  }

  private let iconImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.image = Images.microphone.image
  }
  
  private let lottieView = LottieAnimationView(animation: Animations.recordAnimation.animation).then {
  
    $0.animationSpeed = 1.2
    $0.loopMode = .loop
  }
  
  
  // MARK: - internal properties
  
  weak var delegate: RecordButtonViewDelegate?
  var state: RecoardState = .end {
    didSet {
      guard state != oldValue else { return }
      self.animateBackground(state: state)
      self.handleUI(as: state)
    }
  }
 
  // MARK: - private properties
  
  // MARK: - life cycle
  
  init() {
    super.init(frame: .zero)
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
    
    self.iconImageView.makeConstraints(baseView: self.baseView) { make in
      make.centerX.centerY.equalToSuperview()
      make.width.height.equalTo(30)
    }
    
    self.lottieView.makeConstraints(baseView: self.baseView) { make in
      make.centerX.centerY.equalToSuperview()
      make.width.height.equalTo(70)
    }
  }
 
  // MARK: - internal method
  
  
  // MARK: - private method
  
  private func handleUI(as state: RecoardState) {
    switch state {
      case .start:
        self.hideIcon()
        self.startRecordAnimation()
      case .end:
        self.exposeIcon()
        self.stopRecordAnimation()
    }
  }
  
  private func exposeIcon() {
    UIView.animate(withDuration: 0.2) {
      self.iconImageView.alpha = 1
    }
  }
  
  private func hideIcon() {
    UIView.animate(withDuration: 0.2) {
      self.iconImageView.alpha = 0
    }
  }
  
  private func startRecordAnimation() {
    self.lottieView.play { _ in
      UIView.animate(withDuration: 0.2, animations: { [weak self] in
        self?.lottieView.alpha = 1.0
      })
    }
  }
 
  private func stopRecordAnimation() {
    UIView.animate(withDuration: 0.2, animations: { [weak self] in
      self?.lottieView.alpha = 0
    }, completion: { isStarted in
      self.lottieView.stop()
    })
  }
  
  private func animateBackground(state: RecoardState) {
    var settableColor: UIColor = .clear
    switch state {
      case .start:
        settableColor = .black
      case .end:
        settableColor = Colors.secondary.color
    }
    UIView.transition(with: self.baseView, duration: 0.2) {
      self.baseView.backgroundColor = settableColor
    }
  }
}


class RecordButtonViewDelegateProxy: DelegateProxy<RecordButtonView, RecordButtonViewDelegate>, DelegateProxyType, RecordButtonViewDelegate {
  static func registerKnownImplementations() {
    self.register { RecordButtonViewDelegateProxy(
      parentObject: $0,
      delegateProxy: RecordButtonViewDelegateProxy.self)
    }
  }
  
  static func currentDelegate(for object: RecordButtonView) -> RecordButtonViewDelegate? {
    return object.delegate
  }
  
  static func setCurrentDelegate(_ delegate: RecordButtonViewDelegate?, to object: RecordButtonView) {
    return object.delegate = delegate
  }
}

extension Reactive where Base: RecordButtonView {
  var delegate: DelegateProxy<RecordButtonView, RecordButtonViewDelegate> {
    return RecordButtonViewDelegateProxy.proxy(for: base)
  }
  
  var didTap: ControlEvent<Void> {
    let source: Observable<Void> = delegate
      .methodInvoked(#selector(RecordButtonViewDelegate.tap(_:)))
      .map { _ in }
    return ControlEvent(events: source)
  }
}
