import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Talky",
  platform: .iOS,
  product: .app,
  dependencies: [
    .snapkit,
    .reactorkit,
    .rxswift,
    .rxcocoa,
    .alamofire,
    .moya,
    .rxmoya,
    .TalkyAssets,
    .then,
    .rxflow,
    .swiftyjson,
    .audioRecognizer,
    .lottie
  ],
  testDependencies: [
    .quick,
    .nimble
  ],
  customInfoPlist: .file(path: "Targets/Talky/Resources/TalkyInfo.plist")
)
