import ProjectDescription
import ProjectDescriptionHelpers

let projectName = "Translation"
let project = Project(
  name: projectName,
  targets: Project.makeFrameworkTargets(
    name: projectName,
    customInfoPlist: .default,
    dependencies: [
      .swiftyjson
    ],
    testDependencies: []
  )
)

