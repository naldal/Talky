import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "TalkyDev",
  product: .app,
  dependencies: [
    .snapkit,
    .rxswift,
    .moya,
    .TalkyAssets,
    .then
  ],
  testDependencies: [
    .quick,
    .nimble
  ],
  isIncludeOnly: true
)

