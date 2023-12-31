import ProjectDescription
import ProjectDescriptionHelpers

let projectName = "Translation"
let project = Project(
  name: projectName,
  targets: Project.makeFrameworkTargets(
    name: projectName,
    baseBundleId: "framework.translation.talky",
    customInfoPlist: .default,
    dependencies: [
      .swiftyjson
    ],
    testDependencies: []
  )
)

