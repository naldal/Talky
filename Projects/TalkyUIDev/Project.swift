import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
  name: "TalkyUIDev",
  product: .app,
  dependencies: [],
  testDependencies: [.quick, .nimble],
  isIncludeOnly: false
)

