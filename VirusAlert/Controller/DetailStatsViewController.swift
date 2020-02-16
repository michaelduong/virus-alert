//
//  DetailStatsViewController.swift
//  VirusAlert
//
//  Created by Swift Team Six on 2/15/20.
//  Copyright © 2020 Turnt Labs. All rights reserved.
//

import UIKit
import Neon

final class DetailStatsViewController: UIViewController {
    
    // MARK: - Properties
    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Global Cases"
        label.font = R.font.latoBlack(size: 24)
        label.textAlignment = .center
        return label
    }()
    
    let box1 = StatsCard(statType: "Infected")
    let box2 = StatsCard(statType: "Deaths")
    let box3 = StatsCard(statType: "Recovered")
    
    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Functions
    private func setupUI() {
        view.addSubviews([
            titleLabel,
            box1,
            box2,
            box3
        ])
        setupConstraints()
    }
    
    private func setupConstraints() {
        titleLabel.anchorToEdge(.top, padding: 20, width: 140, height: 29)
        view.groupAndAlign(group: .horizontal, andAlign: .underCentered, views: [box1, box2, box3], relativeTo: titleLabel, padding: 13, width: 105, height: 100)
    }
}
