import ProjectDescription

public extension TargetDependency {
  static let quick: TargetDependency = .external(name: "Quick")
  static let nimble: TargetDependency = .external(name: "Nimble")
  static let snapkit: TargetDependency = .external(name: "SnapKit")
  static let rxswift: TargetDependency = .external(name: "RxSwift")
  static let rxcocoa: TargetDependency = .external(name: "RxCocoa")
  static let alamofire: TargetDependency = .external(name: "Alamofire")
  static let moya: TargetDependency = .external(name: "Moya")
  static let rxmoya: TargetDependency = .external(name: "RxMoya")
  static let then: TargetDependency = .external(name: "Then")
  static let TalkyAssets: TargetDependency = .project(target: "TalkyAssets", path: "../TalkyAssets")
  static let reactorkit: TargetDependency = .external(name: "ReactorKit")
  static let rxflow: TargetDependency = .external(name: "RxFlow")
  static let swiftyjson: TargetDependency = .external(name: "SwiftyJSON")
  static let audioRecognizer: TargetDependency = .project(target: "AudioRecognizer", path: "../AudioRecognizer")
  static let lottie: TargetDependency = .external(name: "Lottie")
  static let nuke: TargetDependency = .external(name: "Nuke")
  static let nukeExtensions: TargetDependency = .external(name: "NukeExtensions")
  static let nukeUI: TargetDependency = .external(name: "NukeUI")
}
