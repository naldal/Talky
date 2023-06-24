import ProjectDescription

extension TargetScript {
    
  enum RunOrderType {
    case pre
    case post
  }
    
  static func makeScript(order: RunOrderType, scriptPath: String, name: String) -> TargetScript {
    switch order {
    case .pre:
      return .pre(script: scriptPath, name: name)
    case .post:
      return .post(script: scriptPath, name: name)
    }
  }
  
  static var lint: TargetScript {
    return self.makeScript(order: .pre,
                           scriptPath: "../Tool/Lint/swiftlint --config \"../Tool/Lint/swiftlint.yml\"",
                           name: "Lint"
    )
  }
}
