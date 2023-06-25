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
import RxCocoa
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
  private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
  private var recognitionTask: SFSpeechRecognitionTask?
  private let audioEngine = AVAudioEngine()
  private var utterlyFinished: Bool = true
  
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
    
    self.reactor?.pulse { $0.translatedText }
      .observe(on: MainScheduler.instance)
      .subscribe(onNext: { [weak self] translatedText in
        print(translatedText)
        self?.motherlandListenerView.setText(text: translatedText)
      })
      .disposed(by: self.disposeBag)
    
    // action
    
    self.recordButton.rx.tap
      .asDriver()
      .debounce(.seconds(1))
      .drive(onNext: { [weak self] _ in
        let feedback = UIImpactFeedbackGenerator(style: .medium)
        feedback.impactOccurred()
        guard var utterlyFinished = self?.utterlyFinished else { return }
        
        if let isRunning = self?.audioEngine.isRunning, isRunning {
          self?.audioEngine.stop()
          self?.recognitionRequest.endAudio()
          self?.stopListening()
          print("음성인식 중단")
          self?.recordButton.backgroundColor = .red
          
        } else if utterlyFinished == true {
          self?.startRecording()
          print("음성인식 시작")
          self?.recordButton.backgroundColor = .green
        }
        
      })
      .disposed(by: self.disposeBag)
    
    
    
  }
  
  // MARK: - internal method
  
  // MARK: - private method

  private func startRecording() {

    self.utterlyFinished = false
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
  
    self.recognitionRequest.shouldReportPartialResults = true

    self.recognitionTask = self.speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { [weak self] (result, error) in
      if result != nil {
        let convertedVoiceString = result?.bestTranscription.formattedString
        self?.engListenerView.setText(text: convertedVoiceString)
        self?.reactor?.action.onNext(.voiceInput(convertedVoiceString ?? ""))
      }
    })
    
    let recordingFormat = self.audioEngine.inputNode.outputFormat(forBus: 0)
    self.audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
      self.recognitionRequest.append(buffer)
    }
    
    self.audioEngine.prepare()
    
    do {
      try audioEngine.start()
    }
    catch {
      print("error: \(error)")
    }
  }
  
  private func stopListening() {
    self.audioEngine.stop()
    self.audioEngine.inputNode.removeTap(onBus: 0)
    self.recognitionTask = nil
    self.utterlyFinished = true
  }
}

