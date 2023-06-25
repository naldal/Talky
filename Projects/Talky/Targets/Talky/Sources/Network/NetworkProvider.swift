//
//  NetworkProvider.swift
//  Talky
//
//  Created by 송하민 on 2023/06/25.
//  Copyright © 2023 TeamTalky. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import Alamofire
import RxSwift
import RxCocoa

protocol Networkable {
  associatedtype Target
  func request(target: Target) -> Observable<Result<Data, Error>>
}

class NetworkProvider<Target: TargetType> {
  private var isStubbing = false
  private var isCustomCatch = false
  public var provider: MoyaProvider<Target>
  public let dispatchQueue = DispatchQueue(label: "queue.network.talky", qos: .default)
  
  let loggerPlugin = NetworkLoggerPlugin()
  
  let customEndpointClosure = { (target: Target) -> Endpoint in
    return Endpoint(
      url: URL(target: target).absoluteString,
      sampleResponseClosure: { .networkResponse(200, target.sampleData) },
      method: target.method,
      task: target.task,
      httpHeaderFields: target.headers
    )
  }
  
  init(isStub: Bool = false, isCustomCatch: Bool = false) {
    self.isStubbing = isStub
    self.isCustomCatch = isCustomCatch
    if isStub {
      self.provider = MoyaProvider<Target>(
        endpointClosure: customEndpointClosure,
        stubClosure: MoyaProvider.immediatelyStub,
        plugins: [loggerPlugin]
      )
    } else {
      self.provider = MoyaProvider<Target>(
        stubClosure: MoyaProvider.neverStub,
        callbackQueue: nil,
        session: AlamofireSession.configuration,
        plugins: [loggerPlugin]
      )
    }
  }
  
  deinit {
    print("network provider has deinited")
  }
}

extension NetworkProvider: Networkable {
  
  func request(target: Target) -> Observable<Result<Data, Error>> {
    
    if self.isStubbing {
      let stubRequest = self.provider.rx.request(target, callbackQueue: self.dispatchQueue)
      
      return stubRequest
        .asObservable()
        .map { response in
          return .success(response.data)
        }
        .catch { error in
          return .just(.failure(error))
        }
    } else {
      let online = networkEnable()
      
      return online
        .take(1)
        .flatMap { isOnline in
          return self.provider.rx.request(
            target,
            callbackQueue: self.dispatchQueue
          )
          .filterSuccessfulStatusCodes()
          .map { response in
            return .success(response.data)
          }
          .catch { error in
            return .just(.failure(error))
          }
        }
      
    }
  }
}


public class AlamofireSession: Alamofire.Session {
  
  public static let configuration: Alamofire.Session = {
    let configuration = URLSessionConfiguration.default
    configuration.headers = HTTPHeaders.default
    configuration.timeoutIntervalForRequest = 60
    configuration.timeoutIntervalForResource = 60
    configuration.requestCachePolicy = NSURLRequest.CachePolicy.useProtocolCachePolicy
    
    return Alamofire.Session(configuration: configuration)
  }()
}

private func networkEnable() -> Observable<Bool> {
  ReachabilityManager.shared.reach
}

// MARK: - ReachabilityManager

public class ReachabilityManager: NSObject {
  
  internal static let shared = ReachabilityManager()
  
  let reachSubject = ReplaySubject<Bool>.create(bufferSize: 1)
  var reach: Observable<Bool> {
    reachSubject.asObservable()
      .do(onNext: { reachable in
        if !reachable {
          print("네트워크에 연결할 수 없습니다.")
        }
      })
  }
  
  override private init() {
    super.init()
    NetworkReachabilityManager.default?.startListening(onUpdatePerforming: { status in
      let reachable = (status == .notReachable || status == .unknown) ? false : true
      self.reachSubject.onNext(reachable)
    })
  }
}
