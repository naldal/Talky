import ProjectDescription

let dependencies = Dependencies(
  carthage: CarthageDependencies([]),
  swiftPackageManager: SwiftPackageManagerDependencies([
    .remote(url: "https://github.com/Quick/Quick.git", requirement: .branch("master")),
    .remote(url: "https://github.com/Quick/Nimble.git", requirement: .branch("main")),
    .remote(url: "https://github.com/SnapKit/SnapKit.git", requirement: .exact("5.0.1")),
    .remote(url: "https://github.com/ReactiveX/RxSwift.git", requirement: .exact("6.5.0")),
    .remote(url: "https://github.com/Alamofire/Alamofire.git", requirement: .exact("5.7.0")),
    .remote(url: "https://github.com/naldal/Moya.git", requirement: .branch("master")),
    .remote(url: "https://github.com/devxoul/Then.git", requirement: .exact("3.0.0")),
    .remote(url: "https://github.com/ReactorKit/ReactorKit.git", requirement: .exact("3.2.0")),
    .remote(url: "https://github.com/RxSwiftCommunity/RxFlow.git", requirement: .branch("main")),
    .remote(url: "https://github.com/SwiftyJSON/SwiftyJSON.git", requirement: .branch("master")),
    .remote(url: "https://github.com/airbnb/lottie-spm.git", requirement: .exact("4.2.0")),
    .remote(url: "https://github.com/kean/Nuke.git", requirement: .exact("12.1.2"))
  ], productTypes: [
    "Quick": .framework,
    "Nimble": .framework,
    "SnapKit": .staticFramework,
    "Alamofire": .staticFramework,
    "RxSwift": .staticFramework,
    "RxCocoa": .staticFramework,
    "Moya": .staticFramework,
    "Then": .staticFramework,
    "ReactorKit": .staticFramework,
    "RxFlow": .staticFramework,
    "SwiftyJSON": .staticFramework,
    "Lottie": .staticFramework,
    "Nuke": .staticFramework,
    "NukeExtensions": .staticFramework
  ])
)
