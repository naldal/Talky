import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "TalkyUIDev",
  product: .app,
  dependencies: [
    .TalkyAssets,
    .rxswift,
    .rxcocoa
  ],
  testDependencies: [.quick, .nimble],
  isIncludeOnly: false
)

