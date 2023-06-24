import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "TalkyDev",
  product: .app,
  dependencies: [],
  testDependencies: [.quick, .nimble],
  additionalTargets: [],
  isIncludeOnly: true
)

