import ProjectDescription

let dependencies = Dependencies(
  carthage: CarthageDependencies([]),
  swiftPackageManager: SwiftPackageManagerDependencies([
    .remote(url: "https://github.com/Quick/Quick.git", requirement: .branch("master")),
    .remote(url: "https://github.com/Quick/Nimble.git", requirement: .branch("main")),
    .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .exact("5.0.1")),
    .remote(url: "https://github.com/ReactiveX/RxSwift", requirement: .exact("6.5.0")),
    .remote(url: "https://github.com/Moya/Moya", requirement: .exact("15.0.3")),
    .remote(url: "https://github.com/devxoul/Then", requirement: .exact("3.0.0"))
  ], productTypes: [
    "Quick": .framework,
    "Nimble": .framework,
    "SnapKit": .staticFramework,
    "RxSwift": .staticFramework,
    "Moya": .staticFramework,
    "Then": .staticFramework
  ])
)
