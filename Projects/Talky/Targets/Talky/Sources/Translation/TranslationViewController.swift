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
import Speech
import ReactorKit
import RxSwift

class TranslationViewController: UIViewController, View {

  
  // MARK: - components
  
  private let backgroundView = UIView().then {
    $0.backgroundColor = Colors.white.color
  }
  
  private let baseView = UIView().then {
    $0.backgroundColor = .clear
  }
  
  private let engListenerView = ListerView().then {
    $0.baseColor = Colors.white.color
  }
  
  private let motherlandListenerView = ListerView().then {
    $0.baseColor = .blue
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
    
    self.baseView.makeConstraints(baseView: self.backgroundView) { make in
      make.edges.equalToSuperview()
    }
    
    self.engListenerView.makeConstraints(baseView: self.baseView) { make in
      make.top.leading.trailing.equalToSuperview()
      make.height.equalToSuperview().dividedBy(2)
    }
    
    self.motherlandListenerView.makeConstraints(baseView: self.baseView) { make in
      make.top.equalTo(self.engListenerView.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }
    
  }
  
  // MARK: - bind
  
  func bind(reactor: TranslationReactor) {
    
  }
  
  // MARK: - internal method
  
  // MARK: - private method
}
  
