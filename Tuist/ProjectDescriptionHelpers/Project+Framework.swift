import ProjectDescription

extension Project {
    
  public static func makeFrameworkTargets(
      name: String,
      frameworkType: Product = .staticFramework,
      baseBundleId: String = "com.tuistTemplate",
      deploymentTarget: DeploymentTarget? = .iOS(targetVersion: "15.0", devices: [.iphone]),
      customInfoPlist: InfoPlist,
      dependencies: [TargetDependency],
      testDependencies: [TargetDependency]
  ) -> [Target] {
        
    let scripts: [TargetScript] = [.lint]
          
    let mainTarget = Target(
      name: name,
      platform: .iOS,
      product: frameworkType,
      bundleId: "\(baseBundleId).\(name)",
      deploymentTarget: deploymentTarget,
      infoPlist: customInfoPlist,
      sources: ["Targets/\(name)/Sources/**"],
      resources: ["Targets/\(name)/Resources/**"],
      scripts: scripts,
      dependencies: dependencies
    )
          
    let testTarget = Target(
      name: "\(name)Tests",
      platform: .iOS,
      product: .unitTests,
      bundleId: "\(baseBundleId).\(name)Tests",
      deploymentTarget: deploymentTarget,
      infoPlist: .default,
      sources: ["Targets/\(name)/Sources/**"],
      resources: ["Targets/\(name)/Resources/**"],
      dependencies: [.target(name: name)] + testDependencies
    )
          
    let sampleApp = Target(
      name: "\(name)SampleApp",
      platform: .iOS,
      product: .app,
      bundleId: "\(baseBundleId).\(name)SampleApp",
      deploymentTarget: deploymentTarget,
      infoPlist: customInfoPlist,
      sources: ["Targets/\(name)/Sources/**"],
      resources: ["Targets/\(name)/Resources/**"],
      dependencies: [.target(name: name)]
    )
          
    return [mainTarget, testTarget, sampleApp]
  }
}
