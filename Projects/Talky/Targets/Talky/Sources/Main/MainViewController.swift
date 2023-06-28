//
//  MainViewController.swift
//  Talky
//
//  Created by 송하민 on 2023/06/24.
//

import UIKit
import SnapKit
import Then
import TalkyAssets
import ReactorKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController, View {
  
  
  // MARK: - components
  
  private let backgroundView = UIView().then {
    $0.backgroundColor = Colors.primary.color
  }
  
  private let baseView = UIView().then {
    $0.backgroundColor = .clear
  }
  
  private let separatorView = UIView().then {
    $0.backgroundColor = Colors.primary.color
  }
  
  private let voiceListenerView = ListerView().then {
    $0.setPlaceholder(text: "마이크를 켜주세요")
    $0.setLanguage(lang: "한국어")
  }
  private let translationListenerView = ListerView().then {
    $0.setPlaceholder(text: "번역 준비 중")
    $0.setLanguage(lang: "English")
  }
  private let recordButton = RecordButtonView()
  
  
  // MARK: - private properties
    
  // MARK: - internal properties
  
  var disposeBag = DisposeBag()
  
  
  // MARK: - life cycle
  
  init(reactor: MainReactor) {
    super.init(nibName: nil, bundle: nil)
    self.reactor = reactor
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func loadView() {
    super.loadView()
    self.layout()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
  // MARK: - layout
  
  func layout() {
    
    self.backgroundView.makeConstraints(baseView: self.view) { make in
      make.edges.equalToSuperview()
    }
    
    self.recordButton.makeConstraints(baseView: self.backgroundView) { make in
      let safeGuide = self.view.safeAreaLayoutGuide
      make.centerX.equalToSuperview()
      make.height.equalTo(60)
      make.width.equalTo(100)
      make.bottom.equalTo(safeGuide)
    }
    
    self.baseView.makeConstraints(baseView: self.backgroundView) { make in
      let safeGuide = self.view.safeAreaLayoutGuide
      make.top.equalTo(safeGuide).offset(24)
      make.bottom.equalTo(self.recordButton.snp.top).offset(-12)
      make.leading.trailing.equalToSuperview().inset(16)
    }
    
    self.separatorView.makeConstraints(baseView: self.baseView) { make in
      make.centerY.leading.trailing.equalToSuperview()
      make.height.equalTo(1)
    }
    
    self.voiceListenerView.makeConstraints(baseView: self.baseView) { make in
      make.top.leading.trailing.equalToSuperview()
      make.bottom.equalTo(self.separatorView.snp.top).offset(-16)
    }
    
    self.translationListenerView.makeConstraints(baseView: self.baseView) { make in
      make.top.equalTo(self.separatorView.snp.bottom).offset(16)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview().inset(8)
    }
    
    self.backgroundView.bringSubviewToFront(self.recordButton)
  }
  
  // MARK: - bind
  
  func bind(reactor: MainReactor) {
    
    reactor.state.map { $0.error }
      .compactMap({ $0 })
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] error in
        let alert = UIAlertController(title: error.description, message: nil, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        self?.present(alert, animated: true, completion: nil)
      })
      .disposed(by: self.disposeBag)
    
    // state
    
    reactor.pulse { $0.recognitionState }
      .compactMap({ $0 })
      .subscribe(onNext: { [weak self] state in
        switch state {
          case .starting, .running:
            self?.recordButton.state = .start
            self?.voiceListenerView.setPlaceholder(text: "듣고있습니다...")
            self?.translationListenerView.setPlaceholder(text: "번역 준비 완료")
          case .canceling, .finishing, .completed:
            self?.recordButton.state = .end
          @unknown default:
            break
        }
      })
      .disposed(by: self.disposeBag)
    
    reactor.pulse { $0.voiceConvertedText }
      .compactMap({ $0 })
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] text in
        self?.voiceListenerView.setText(text: text)
        self?.reactor?.action.onNext(.voiceInput(text))
      })
      .disposed(by: self.disposeBag)
    
    reactor.pulse { $0.translatedText }
      .skip(1)
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] translatedText in
        self?.translationListenerView.setText(text: translatedText)
      })
      .disposed(by: self.disposeBag)
    
    // action
    
    self.recordButton.rx.didTap
      .asDriver()
      .throttle(.seconds(1))
      .drive(onNext: { _ in
        reactor.action.onNext(.tappedRecord)
      })
      .disposed(by: self.disposeBag)
      
    
    
    
  }
  
  // MARK: - internal method
  
  // MARK: - private method

}

