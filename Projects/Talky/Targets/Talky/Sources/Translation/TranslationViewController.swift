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
import AVFoundation

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
  
  private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))
  private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
  private var recognitionTask: SFSpeechRecognitionTask?
  private let audioEngine = AVAudioEngine()
  
  
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
    
    self.recordButton.rx.tap
      .asDriver()
      .debounce(.seconds(1))
      .drive(onNext: { [weak self] _ in
        if let isRunning = self?.audioEngine.isRunning, isRunning {
          self?.audioEngine.stop()
          self?.recognitionRequest?.endAudio()
          print("음성인식 중단")
        } else {
          self?.startRecording()
          print("음성인식 시작")
        }
        
      })
      .disposed(by: self.disposeBag)
  }
  
  // MARK: - internal method
  
  // MARK: - private method

  private func startRecording() {
    recognitionTask?.cancel()
    recognitionTask = nil
    
    
    do {
      let audioSession = AVAudioSession.sharedInstance()
      try audioSession.setCategory(AVAudioSession.Category.record)
      try audioSession.setMode(AVAudioSession.Mode.measurement)
      try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    }
    catch {
      print("error: \(error)")
    }
    
    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    
    let inputNode = audioEngine.inputNode
    
    guard let recognitionRequest = recognitionRequest else {
      fatalError("")
    }
    
    recognitionRequest.shouldReportPartialResults = true
    
    recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
      
      var isFinal = false
      
      if result != nil {
        let convertedVoiceString = result?.bestTranscription.formattedString
        self.engListenerView.setVoiceText(voice: convertedVoiceString)
        isFinal = (result?.isFinal)!
      }
      
      if isFinal {
        self.audioEngine.stop()
        inputNode.removeTap(onBus: 0)
        
        self.recognitionRequest = nil
        self.recognitionTask = nil
      }
    })
    
    let recordingFormat = inputNode.outputFormat(forBus: 0)
    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
      self.recognitionRequest?.append(buffer)
    }
    
    audioEngine.prepare()
    
    do {
      try audioEngine.start()
    }
    catch {
      print("error: \(error)")
    }
  }
}

