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
    .moya,
    .TalkyAssets,
    .then,
    .rxflow
  ],
  testDependencies: [
    .quick,
    .nimble
  ],
  bridgingHeaderPath: "Support/BridgingHeader/Talky-Bridging-Header.h",
  customInfoPlist: .file(path: "Targets/Talky/Resources/TalkyInfo.plist")
)
