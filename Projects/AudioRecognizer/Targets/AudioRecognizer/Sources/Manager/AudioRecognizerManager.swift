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
  private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
  private var recognitionTask: SFSpeechRecognitionTask?
  private let audioEngine = AVAudioEngine()
  
  
  // MARK: - life cycle
  
  static let shared: AudioRecognizerManager = AudioRecognizerManager(isListenWhileTalk: true)
  init(isListenWhileTalk: Bool) {
    
  }
  private init() { }
  
  
  // MARK: - internal method
  
  func startRecording() -> Observable<Result<Void, AudioRecognizerError>> {
    return self.initializeAudioSession()
      .flatMap { [weak self] result -> Observable<Result<Void, AudioRecognizerError>> in
        switch result {
          case .success():
            return self?.runRecognizeTask() ?? .just(.failure(.init(.selfIsNil)))
          case .failure(let error):
            return .just(.failure(error))
        }
      }
      .flatMap { [weak self] result -> Observable<Result<Void, AudioRecognizerError>> in
        switch result {
          case .success():
            return self?.startAudioEngine() ?? .just(.failure(.init(.selfIsNil)))
          case .failure(let error):
            return .just(.failure(error))
        }
      }
  }

  func stopRecording() {
    self.audioEngine.stop()
    self.audioEngine.inputNode.removeTap(onBus: 0)
    self.recognitionTask = nil
  }
  
  // MARK: - private method
  
  private func initializeAudioSession() -> Observable<Result<Void, AudioRecognizerError>> {
    return Observable.create { emitter in
      if self.recognitionRequest == nil {
        let recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest.shouldReportPartialResults = true
        self.recognitionRequest = recognitionRequest
      }
      let audioSession = AVAudioSession.sharedInstance()
      do {
        try audioSession.setCategory(AVAudioSession.Category.record)
        try audioSession.setMode(AVAudioSession.Mode.measurement)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        
        emitter.onNext(.success(()))
        emitter.onCompleted()
      } catch {
        emitter.onNext(.failure(AudioRecognizerError.init(.audioSessionError)))
        emitter.onCompleted()
      }
      return Disposables.create()
    }
  }
  
  private func runRecognizeTask() -> Observable<Result<Void, AudioRecognizerError>> {
    return Observable.create { observer in
      guard let recognitionRequest = self.recognitionRequest else {
        observer.onNext(.failure(.init(.selfIsNil)))
        return Disposables.create()
      }
      let task = self.speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { [weak self] (result, error) in
        guard let result = result else { return observer.onNext(.failure(.init(.recognitionTaskError)))}
        let convertedVoiceString = result.bestTranscription.formattedString
//        self?.recognizedTextSubject.onNext(convertedVoiceString)
        observer.onNext(.success(()))
        observer.onCompleted()
      })
      return Disposables.create {
        task?.cancel()
      }
    }
  }
  
  func startAudioEngine() -> Observable<Result<Void, AudioRecognizerError>> {
    return Observable.create { emitter in
      guard let recognitionRequest = self.recognitionRequest else {
        emitter.onNext(.failure(.init(.selfIsNil)))
        return Disposables.create()
      }
      let recordingFormat = self.audioEngine.inputNode.outputFormat(forBus: 0)
      self.audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
        recognitionRequest.append(buffer)
      }
      
      do {
        self.audioEngine.prepare()
        try self.audioEngine.start()
        
        emitter.onNext(.success(()))
        emitter.onCompleted()
      } catch {
        emitter.onNext(.failure(.init(.startFailed)))
        emitter.onCompleted()
      }
      
      return Disposables.create {
        self.audioEngine.stop()
        self.audioEngine.inputNode.removeTap(onBus: 0)
      }
    }
  }
  
  private func refreshSFSpeechRecognizer() {
    self.speechRecognizer = SFSpeechRecognizer(locale: self.currentRecognizationLanguage)
  }
}
