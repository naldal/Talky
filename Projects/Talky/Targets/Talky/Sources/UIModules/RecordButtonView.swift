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
    $0.layer.shadowOffset = CGSize(width: 0, height: 5)
    $0.layer.shadowOpacity = 0.7
    $0.layer.shadowRadius = 1
    $0.layer.shadowColor = Colors.secondaryShadow.color.cgColor
    $0.layer.masksToBounds = false
    $0.layer.cornerRadius = 30
    $0.isUserInteractionEnabled = true
    let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
    longPressGesture.minimumPressDuration = 0
    $0.addGestureRecognizer(longPressGesture)
    $0.backgroundColor = Colors.secondary.color
  }
  
  @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
    switch gesture.state {
      case .began:
        self.transformPressOn()
      case .ended, .cancelled:
        self.delegate?.tap?(self)
        self.transformPressOff()
      default:
        break
    }
  }

  private let iconImageView = UIImageView().then {
    $0.contentMode = .scaleAspectFill
    $0.image = Images.microphone.image
  }
  
  private let lottieView = LottieAnimationView(animation: Animations.recordAnimation.animation).then {
    $0.animationSpeed = 3
    $0.loopMode = .loop
  }
  
  
  // MARK: - internal properties
  
  weak var delegate: RecordButtonViewDelegate?
  var state: RecoardState = .end {
    didSet {
      guard state != oldValue else { return }
      self.animateButtonColors(state: state)
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
    self.lottieView.makeConstraints(baseView: baseView) { make in
      make.centerX.centerY.equalToSuperview()
      make.width.height.equalTo(70)
    }
    self.lottieView.play()
  }
 
  private func stopRecordAnimation() {
    UIView.animate(withDuration: 0.2, animations: { [weak self] in
      self?.lottieView.removeFromSuperview()
    }, completion: { isStarted in
      self.lottieView.stop()
    })
  }
  
  private func animateButtonColors(state: RecoardState) {
    var settableBackgroundColor: UIColor = .clear
    var settableShadowColor: UIColor = .clear
    switch state {
      case .start:
        settableBackgroundColor = .black
        settableShadowColor = .black
      case .end:
        settableBackgroundColor = Colors.secondary.color
        settableShadowColor = Colors.secondaryShadow.color
    }
    UIView.transition(with: self.baseView, duration: 0.2) {
      self.baseView.backgroundColor = settableBackgroundColor
      self.baseView.layer.shadowColor = settableShadowColor.cgColor
    }
  }
  
  private func transformPressOn() {
    var transform = baseView.transform
    transform = transform.translatedBy(x: 0, y: 5)
    self.baseView.layer.shadowOffset = .zero
    self.baseView.transform = transform
  }
  
  private func transformPressOff() {
    var transform = baseView.transform
    transform = transform.translatedBy(x: 0, y: -5)
    self.baseView.layer.shadowOffset = CGSize(width: 0, height: 5)
    self.baseView.transform = transform
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
