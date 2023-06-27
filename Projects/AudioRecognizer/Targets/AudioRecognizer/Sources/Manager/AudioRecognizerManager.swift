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
  
  static let shared: AudioRecognizerManager = AudioRecognizerManager()
  private init() { }
  
  
  // MARK: - internal method
  
  func startRecording() {

    self.startAudioSession()
    self.setIsReportParticialResult(isParticial: true)
    self.startRecognitionTask()
    self.audioEngineAppendBuffer()
    self.startAudioEngine()
  }
  
  func stopRecording() {
    if audioEngine.isRunning {
      audioEngine.stop()
      audioEngine.inputNode.removeTap(onBus: 0)
      recognitionTask?.cancel()
      recognizeTaskStatus.onNext(.canceling)
      recognitionTask = nil
      recognizeTaskStatus.onNext(.completed)
    }
  }
  
  // MARK: - private method
  
  
  private func refreshSFSpeechRecognizer() {
    self.speechRecognizer = SFSpeechRecognizer(locale: self.currentRecognizationLanguage)
  }
  
  private func startAudioSession() {
    recognitionTask?.cancel()
    recognitionTask = nil
    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    do {
      let audioSession = AVAudioSession.sharedInstance()
      try audioSession.setCategory(AVAudioSession.Category.record)
      try audioSession.setMode(AVAudioSession.Mode.measurement)
      try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    } catch {
      print("error: \(error)")
    }
  }
  
  private func setIsReportParticialResult(isParticial: Bool) {
    self.recognitionRequest.shouldReportPartialResults = isParticial
  }
  
  private func startRecognitionTask() {
    if self.recognitionTask != nil {
      self.recognitionTask = nil
    }
    self.recognizeTaskStatus.onNext(.starting)
    self.recognitionTask = self.speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { [weak self] (result, error) in
      if result != nil {
        let convertedVoiceString = result?.bestTranscription.formattedString
        self?.recognizedTextSubject.onNext(convertedVoiceString)
      }
    })
  }
  
  private func audioEngineAppendBuffer() {
    let recordingFormat = self.audioEngine.inputNode.outputFormat(forBus: 0)
    self.audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] (buffer, when) in
      self?.recognitionRequest.append(buffer)
    }
  }
  
  private func startAudioEngine() {
    do {
      self.audioEngine.prepare()
      try audioEngine.start()
      self.recognizeTaskStatus.onNext(.running)
    } catch {
      print("error: \(error)")
    }
  }

}
