import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "TalkyDev",
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
  isIncludeOnly: true
)

