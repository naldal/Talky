import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Talky",
  platform: .iOS,
  product: .app,
  dependencies: [
    .snapkit,
    .rxswift,
    .moya,
    .project(target: "TalkyAssets", path: "../TalkyAssets")
  ],
  testDependencies: [
    .quick,
    .nimble
  ],
  bridgingHeaderPath: "Support/BridgingHeader/Talky-Bridging-Header.h",
  customInfoPlist: .file(path: "Support/InfoPlist/Info.plist")
)
