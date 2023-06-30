//
//  Project.swift
//  ProjectDescriptionHelpers
//
//  Created by 송하민 on 2023/06/24.
//

import ProjectDescription
import ProjectDescriptionHelpers

let projectName = "TalkyAssets"
let project = Project(
  name: projectName,
  targets: Project.makeFrameworkTargets(
    name: projectName,
    customInfoPlist: .default,
    dependencies: [
      .lottie,
      .nuke,
      .nukeExtensions,
      .nukeUI
    ],
    testDependencies: []
  ),
  resourceSynthesizers: [
    .assets(),
    .fonts(),
    .strings(),
    .custom(name: "Lottie", parser: .json, extensions: ["lottie"])
  ]
)

