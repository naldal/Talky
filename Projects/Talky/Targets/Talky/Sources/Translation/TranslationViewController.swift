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
import ReactorKit
import RxSwift
import RxCocoa

class TranslationViewController: UIViewController, View {
  
  
  // MARK: - components
  
  private let backgroundView = UIView().then {
    $0.backgroundColor = Colors.brown.color
  }
  
  private let baseView = UIView().then {
    $0.backgroundColor = .clear
  }
  
  private let separatorView = UIView().then {
    $0.backgroundColor = Colors.gray.color
  }
  
  private let engListenerView = ListerView().then {
    $0.baseColor = Colors.white.color
  }
  
  private let motherlandListenerView = ListerView().then {
    $0.baseColor = Colors.white.color
  }
  
  private let recordButton = UIButton().then {
    $0.backgroundColor = .red
    $0.layer.cornerRadius = 30
  }
  
  
  // MARK: - private properties
    
  // MARK: - internal properties
  
  var disposeBag = DisposeBag()
  
  
  // MARK: - life cycle
  
  init(reactor: TranslationReactor) {
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
    
    self.separatorView.makeConstraints(baseView: self.backgroundView) { make in
      make.centerY.leading.trailing.equalToSuperview()
      make.height.equalTo(15)
    }
    
    self.recordButton.makeConstraints(baseView: self.backgroundView) { make in
      make.centerX.centerY.equalToSuperview()
      make.width.height.equalTo(60)
    }
    
    self.baseView.makeConstraints(baseView: self.backgroundView) { make in
      let safeGuide = self.view.safeAreaLayoutGuide
      make.top.bottom.equalTo(safeGuide)
      make.leading.trailing.equalToSuperview().inset(15)
    }
    
    self.engListenerView.makeConstraints(baseView: self.baseView) { make in
      make.top.leading.trailing.equalToSuperview()
      make.bottom.equalTo(self.separatorView.snp.top)
    }
    
    self.motherlandListenerView.makeConstraints(baseView: self.baseView) { make in
      make.bottom.leading.trailing.equalToSuperview()
      make.top.equalTo(self.separatorView.snp.bottom)
    }
    
    self.backgroundView.bringSubviewToFront(self.recordButton)
  }
  
  // MARK: - bind
  
  func bind(reactor: TranslationReactor) {
    
    
    // state
    
    reactor.pulse { $0.recognitionState }
      .compactMap({ $0 })
      .subscribe(onNext: { state in
        switch state {
          case .starting:
            print("starting")
          case .running:
            print("running")
          case .finishing:
            print("finishing")
          case .canceling:
            print("canceling")
          case .completed:
            print("completed")
          @unknown default:
            break
        }
      })
      .disposed(by: self.disposeBag)
    
    reactor.pulse { $0.voiceConvertedText }
      .compactMap({ $0 })
      .subscribe(onNext: { text in
        print("converted text ~> \(text)")
      })
      .disposed(by: self.disposeBag)
    
    reactor.pulse { $0.translatedText }
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] translatedText in
        print(translatedText)
        self?.motherlandListenerView.setText(text: translatedText)
      })
      .disposed(by: self.disposeBag)
    
    // action
    
    self.recordButton.rx.tap
      .asDriver()
      .drive(onNext: { _ in
        reactor.action.onNext(.tappedRecord)
      })
      .disposed(by: self.disposeBag)
      
    
    
    
  }
  
  // MARK: - internal method
  
  // MARK: - private method

}

