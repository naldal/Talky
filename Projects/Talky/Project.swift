import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "Talky",
  platform: .iOS,
  product: .app,
  dependencies: [],
  testDependencies: [.quick, .nimble],
  bridgingHeaderPath: "Support/BridgingHeader/Talky-Bridging-Header.h",
  customInfoPlist: .file(path: "Support/InfoPlist/Info.plist"),
  additionalTargets: []
)
