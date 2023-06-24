import ProjectDescription

public extension Project {
    
  static func makeModule(
    name: String,
    platform: Platform = .iOS,
    product: Product,
    baseBundleId: String = "com.tuistTemplate",
    organizationName: String = "organizationName",
    packages: [Package] = [],
    deploymentTarget: DeploymentTarget? = .iOS(targetVersion: "15.0", devices: [.iphone]),
    dependencies: [TargetDependency] = [],
    testDependencies: [TargetDependency] = [],
    bridgingHeaderPath: String? = nil,
    customInfoPlist: InfoPlist = .default,
    additionalTargets: [String],
    isIncludeOnly: Bool = false
  ) -> Project {
        
    var originName: String {
      return "Talky"
    }
          
    // MARK: - Targets
          
    let targetAdditionalSourcePath: [String] = [
      "../\(originName)/Targets/\(originName)/Sources/**"
    ]
          
    let targetAdditionalResourcePath: [String] = [
      "../\(originName)/Targets/\(originName)/Resources/**"
    ]
          
    let targets: [Target] = self.makeTargets(
      targetName: name,
      originName: originName,
      platform: platform,
      product: product,
      baseBundleId: baseBundleId,
      deploymentTarget: deploymentTarget,
      dependencies: dependencies,
      testDependencies: testDependencies,
      additionalSourcePaths: targetAdditionalSourcePath,
      additionalResourcePaths: targetAdditionalResourcePath,
      isIncludeOnly: isIncludeOnly
    )
          
          
    // MARK: - Build settings
          
    var baseSetting: ProjectDescription.SettingsDictionary {
      if let bridgingHeaderPath {
        return ["SWIFT_OBJC_BRIDGING_HEADER": SettingValue(stringLiteral: bridgingHeaderPath)]
      }
      return [:]
    }
          
    let settings: Settings = .settings(
      base: [:],
      configurations: [
      .debug(
        name: .debug,
        settings: baseSetting,
        xcconfig: "../\(originName)/Targets/\(originName)/XCConfigs/Debug.xcconfig"
      ),
      .release(
        name: .release,
        settings: baseSetting,
        xcconfig: "../\(originName)/Targets/\(originName)/XCConfigs/Release.xcconfig"
      )],
      defaultSettings: .recommended
    )

    return Project(
      name: name,
      organizationName: organizationName,
      packages: packages,
      settings: settings,
      targets: targets,
      resourceSynthesizers: [
        .assets(),
        .strings(),
        .fonts()
      ]
    )
  }
    
    
  // MARK: - make multiple targets
    
  static func makeTargets(
    targetName: String,
    originName: String,
    platform: Platform,
    product: Product,
    baseBundleId: String,
    deploymentTarget: DeploymentTarget?,
    dependencies: [TargetDependency],
    testDependencies: [TargetDependency],
    additionalSourcePaths: [String],
    additionalResourcePaths: [String],
    isIncludeOnly: Bool
  ) -> [Target] {
        
    let sources: SourceFilesList = {
      if targetName != originName {
        let globs: [SourceFileGlob] = {
        var returnValue: [SourceFileGlob] = []
        var excludingSources: [ProjectDescription.Path] = []
        if isIncludeOnly == false {
            returnValue.append(SourceFileGlob.glob("../\(targetName)/Targets/\(targetName)/Sources/**"))
            excludingSources = [
                "../\(originName)/Targets/\(originName)/Sources/AppDelegate.swift",
                "../\(originName)/Targets/\(originName)/Sources/SceneDelegate.swift"
            ]
          }
          for additionalSourcePath in additionalSourcePaths {
            returnValue.append(
              .glob(
                Path(additionalSourcePath),
                excluding: excludingSources
              )
            )
          }
          return returnValue
        }()
        return SourceFilesList(globs: globs)
      } else {
        var returnValue: [String] = additionalSourcePaths
        returnValue.append("../\(originName)/Targets/\(originName)/Sources/**")
        return SourceFilesList(globs: returnValue)
      }
    }()
        
    let resources: ResourceFileElements = {
      if targetName != originName {
        var returnValue: [String] = additionalResourcePaths
        if isIncludeOnly == false {
            returnValue.append("../\(targetName)/Targets/\(targetName)/Resources/**")
        }
        var elements: [ResourceFileElement] = []
        for item in returnValue {
        elements.append(.init(stringLiteral: item))
        }
        return ResourceFileElements(resources: elements)
      } else {
        var returnValue: [String] = additionalResourcePaths
        returnValue.append("../\(originName)/Targets/\(originName)/Resources/**")
        var elements: [ResourceFileElement] = []
        for item in returnValue {
            elements.append(.init(stringLiteral: item))
        }
        return ResourceFileElements(resources: elements)
      }
    }()
  
    // add your own scripts
    let scripts: [TargetScript] = [.lint]
  
    let mainTarget = Target(
      name: targetName,
      platform: platform,
      product: product,
      bundleId: "\(baseBundleId).\(targetName)",
      deploymentTarget: deploymentTarget,
      infoPlist: .file(path: "../\(originName)/Support/InfoPlist/Info.plist"),
      sources: sources,
      resources: resources,
      scripts: scripts,
      dependencies: dependencies
    )
  
    let testTarget = Target(
      name: "\(targetName)Tests",
      platform: platform,
      product: .unitTests,
      bundleId: "\(baseBundleId).\(targetName)Tests",
      deploymentTarget: deploymentTarget,
      infoPlist: .file(path: "../\(originName)/Support/InfoPlist/Info.plist"),
      sources: ["../\(originName)/Targets/\(originName)/Tests/**"],
      resources: ["../\(originName)/Targets/\(originName)/TestResources/**"],
      dependencies: testDependencies
    )
        
    return [mainTarget, testTarget]
  }
}

