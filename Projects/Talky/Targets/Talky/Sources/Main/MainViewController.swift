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
    $0.backgroundColor = Colors.white.color
  }
  
  private let baseView = UIView().then {
    $0.backgroundColor = .clear
  }
  
  private let sourceCountryImageView = UIImageView().then {
    $0.backgroundColor = .gray
  }
  
  private let translateIconImageView = UIImageView().then {
    $0.image = Images.tranlsate.image
  }
  
  private let targetCountryImageView = UIImageView().then {
    $0.backgroundColor = .gray
  }
  
  private lazy var translateCountriesStackView = UIStackView().then {
    $0.alignment = .center
    $0.distribution = .equalSpacing
    $0.axis = .horizontal
    
    $0.addArrangedSubview(sourceCountryImageView)
    $0.addArrangedSubview(translateIconImageView)
    $0.addArrangedSubview(targetCountryImageView)
  }
  
  
  private let separatorView = UIView().then {
    $0.backgroundColor = .clear
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
      make.bottom.equalTo(safeGuide).inset(20)
    }
    
    self.baseView.makeConstraints(baseView: self.backgroundView) { make in
      let safeGuide = self.view.safeAreaLayoutGuide
      make.top.equalTo(safeGuide).offset(100)
      make.bottom.equalTo(self.recordButton.snp.top).offset(-12)
      make.leading.trailing.equalToSuperview().inset(16)
    }
    
    self.separatorView.makeConstraints(baseView: self.baseView) { make in
      make.centerY.leading.trailing.equalToSuperview()
      make.height.equalTo(30)
    }
    
    self.voiceListenerView.makeConstraints(baseView: self.baseView) { make in
      make.top.leading.trailing.equalToSuperview()
      make.bottom.equalTo(self.separatorView.snp.top)
    }
    
    self.translationListenerView.makeConstraints(baseView: self.baseView) { make in
      make.top.equalTo(self.separatorView.snp.bottom)
      make.leading.trailing.equalToSuperview()
      make.bottom.equalToSuperview().inset(8)
    }
    
    self.backgroundView.bringSubviewToFront(self.recordButton)
    
    self.sourceCountryImageView.snp.makeConstraints { make in
      make.width.height.equalTo(32)
    }
    self.targetCountryImageView.snp.makeConstraints { make in
      make.width.height.equalTo(32)
    }
    self.translateIconImageView.snp.makeConstraints { make in
      make.width.height.equalTo(20)
    }
    self.translateCountriesStackView.makeConstraints(baseView: self.backgroundView) { make in
      make.height.equalTo(40)
      make.width.equalTo(100)
      make.trailing.equalTo(self.baseView)
      make.bottom.equalTo(self.baseView.snp.top).offset(-12)
    }
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

