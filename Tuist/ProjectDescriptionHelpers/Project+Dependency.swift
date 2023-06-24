import ProjectDescription

public extension TargetDependency {
  static let quick: TargetDependency = .external(name: "Quick")
  static let nimble: TargetDependency = .external(name: "Nimble")
  static let snapkit: TargetDependency = .external(name: "SnapKit")
  static let rxswift: TargetDependency = .external(name: "RxSwift")
  static let moya: TargetDependency = .external(name: "Moya")
}
