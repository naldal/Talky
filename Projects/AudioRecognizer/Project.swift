//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 송하민 on 2023/06/26.
//

import ProjectDescription
import ProjectDescriptionHelpers

let projectName = "AudioRecognizer"
let project = Project(
  name: projectName,
  targets: Project.makeFrameworkTargets(
    name: projectName,
    baseBundleId: "framework.AudioRecognizer.talky",
    customInfoPlist: .default,
    dependencies: [.rxswift],
    testDependencies: []
  )
)
