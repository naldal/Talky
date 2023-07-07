//
//  UITestViewController.swift
//  TalkyUIDev
//
//  Created by 송하민 on 2023/07/07.
//  Copyright © 2023 TeamTalky. All rights reserved.
//

import UIKit
import Then
import TalkyAssets

final class UITestViewController: UIViewController {
  
  enum TestCases: String, CaseIterable {
    case recordButton
  }
  
  // MARK: - components
  
  private let baseView = UIView()
  
  private lazy var testTableView = UITableView().then {
    $0.register(UITestTableViewCell.self, forCellReuseIdentifier: UITestTableViewCell.className())
    $0.delegate = self
    $0.dataSource = self
  }
  
  
  // MARK: - life cycle
  
  override func viewDidLoad() {
    super.viewDidLoad()
    self.setup()
  }
  
  
  // MARK: - layout
  
  private func setup() {
    baseView.makeConstraints(baseView: self.view) { make in
      make.edges.equalToSuperview()
    }
    
    self.testTableView.makeConstraints(baseView: self.baseView) { make in
      make.edges.equalToSuperview()
    }
  }
  
  
  // MARK: - private method
  
  private func selectCell(cases: TestCases) {
    switch cases {
      case .recordButton:
        let vc = RecordButtonViewUIDev.devViewController()
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
  }
  
}

extension UITestViewController: UITableViewDelegate, UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return TestCases.allCases.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: UITestTableViewCell.className(), for: indexPath) as? UITestTableViewCell else {
      return UITableViewCell()
    }
    cell.configureCell(name: TestCases.allCases[indexPath.row].rawValue)
    return cell
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let testCase = TestCases.allCases[indexPath.row]
    self.selectCell(cases: testCase)
  }
}
