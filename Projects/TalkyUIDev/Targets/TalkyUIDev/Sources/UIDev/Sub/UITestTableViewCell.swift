//
//  UITestTableViewCell.swift
//  TalkyUIDev
//
//  Created by 송하민 on 2023/07/07.
//  Copyright © 2023 TeamTalky. All rights reserved.
//

import UIKit

final class UITestTableViewCell: UITableViewCell, Identifiable {
  
  // MARK: - components
  
  private let baseView = UIView()
  private let nameLabel = UILabel().then {
    $0.font = .font(fonts: .regular, fontSize: 13)
  }
  
  // MARK: - life cycle
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.setup()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  
  // MARK: - configure
  
  func configureCell(name: String) {
    self.nameLabel.text = name
  }
  
  // MARK: - setup
  
  func setup() {
    self.baseView.makeConstraints(baseView: self.contentView) { make in
      make.edges.equalToSuperview()
    }
    
    self.nameLabel.makeConstraints(baseView: self.baseView) { make in
      make.centerY.equalToSuperview()
      make.leading.trailing.equalToSuperview().inset(20)
    }
  }
  
}
