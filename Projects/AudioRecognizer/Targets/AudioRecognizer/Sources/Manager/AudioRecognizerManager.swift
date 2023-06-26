//
//  AudioRecognizerManager.swift
//  AudioRecognizer
//
//  Created by 송하민 on 2023/06/26.
//

import Foundation
import Speech
import AVFoundation
import RxSwift

class AudioRecognizerManager {
  
  enum RecongnizationLanguage: String {
    case Korean
    case English
    case Japanese
    case Thai
  }
  
  // MARK: - internal properties

  var currentRecognizationLanguage: Locale = Locale.current {
    didSet {
      self.refreshSFSpeechRecognizer()
    }
  }
  
  var recognizedTextSubject: PublishSubject<String?> = .init()
  var recognizeTaskStatus: PublishSubject<SFSpeechRecognitionTaskState?> = .init()
  
  
  // MARK: - private properties
  
  private lazy var speechRecognizer = SFSpeechRecognizer(locale: self.currentRecognizationLanguage)
  private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest = SFSpeechAudioBufferRecognitionRequest()
  private var recognitionTask: SFSpeechRecognitionTask?
  private let audioEngine = AVAudioEngine()
  
  
  // MARK: - life cycle
  
  static let shared: AudioRecognizerManager = AudioRecognizerManager(isListenWhileTalk: true)
  init(isListenWhileTalk: Bool) {
    
  }
  private init() { }
  
  
  // MARK: - internal method
  
  func startRecording() {
    self.recognizeTaskStatus.onNext(.starting)
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

    self.recognitionTask = self.speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
      if result != nil {
        let convertedVoiceString = result?.bestTranscription.formattedString
      }
    })
    
    let recordingFormat = self.audioEngine.inputNode.outputFormat(forBus: 0)
    self.audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
      self.recognitionRequest.append(buffer)
    }
    
    self.audioEngine.prepare()
    
    do {
      try audioEngine.start()
      self.recognizeTaskStatus.onNext(.running)
    }
    catch {
      print("error: \(error)")
    }
  }

  func stopRecording() {
    self.audioEngine.stop()
    self.audioEngine.inputNode.removeTap(onBus: 0)
    self.recognitionTask = nil
  }
  
  // MARK: - private method
  
  
  private func refreshSFSpeechRecognizer() {
    self.speechRecognizer = SFSpeechRecognizer(locale: self.currentRecognizationLanguage)
  }
}
