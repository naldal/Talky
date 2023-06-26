import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "TalkyDev",
  product: .app,
  dependencies: [
    .snapkit,
    .reactorkit,
    .rxswift,
    .alamofire,
    .moya,
    .rxmoya,
    .TalkyAssets,
    .then,
    .rxflow,
    .swiftyjson,
    .audioRecognizer
  ],
  testDependencies: [
    .quick,
    .nimble
  ],
  isIncludeOnly: true
)

