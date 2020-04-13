//
//  StatsCard.swift
//  VirusAlert
//
//  Created by Swift Team Six on 2/15/20.
//  Copyright © 2020 Turnt Labs. All rights reserved.
//

import UIKit
import Stevia

final class StatsCard: UIView {
    
    // MARK: - Properties
    let countLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.latoBold(size: 20)
        label.textColor = R.color.hospitalBlue()
        label.textAlignment = .center
        return label
    }()
    
    let statTypeLabel: UILabel = {
        let label = UILabel()
        label.font = R.font.latoBold(size: 16)
        label.textColor = R.color.slateBlack()
        label.textAlignment = .center
        label.text = "Type"
        return label
    }()
    
    // MARK: - Initializers
    required init(statType: String) {
        let customFrame = CGRect(x: 0, y: 0, width: 100, height: 105)
        super.init(frame: customFrame)
        setupUI()
        statTypeLabel.text = "\(statType)"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Functions
    private func setupUI() {
        backgroundColor = .white
        subviews([
            countLabel,
            statTypeLabel
        ])
        self.layer.cornerRadius = 12
        self.addShadow(ofColor: .black, radius: 3, offset: .zero, opacity: 0.10)
        setupConstraints()
    }
    
    private func setupConstraints() {
        countLabel.top(31).height(33).centerHorizontally()
        statTypeLabel.height(19).centerHorizontally().Top == countLabel.Bottom + 10
    }
}
