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
    
    var data: [Feature]!
    
    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadGlobalData()
        setupNotifications()
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
        titleLabel.anchorAndFillEdge(.top, xPad: 20, yPad: 20, otherSize: 29)
        view.groupAndAlign(group: .horizontal, andAlign: .underCentered, views: [box1, box2, box3], relativeTo: titleLabel, padding: 13, width: 105, height: 100)
    }
    
    private func setupNotifications() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(updateDataBoxes(_:)), name: Notification.Name(NotificationName.updateData), object: nil)
        nc.addObserver(self, selector: #selector(loadGlobalData), name: Notification.Name(NotificationName.globalData), object: nil)
    }
    
    // MARK: - Actions
    @objc private func loadGlobalData() {
        Service.shared.fetchMapJSONData(layerType: .region) { [weak self] (result, err) in
            if let err = err {
                print(err)
            }
            
            if let result = result {
                self?.data = result
                var confirmed = 0
                var deaths = 0
                var recovered = 0
                
                guard let data = self?.data else { return }
                for dataPoint in data {
                    confirmed += dataPoint.attributes.confirmed
                    deaths += dataPoint.attributes.deaths
                    recovered += dataPoint.attributes.recovered
                }
                
                DispatchQueue.main.async {
                    self?.box1.countLabel.text = String(describing: confirmed)
                    self?.box2.countLabel.text = String(describing: deaths)
                    self?.box3.countLabel.text = String(describing: recovered)
                    self?.titleLabel.text = "Global Cases"
                }
            }
        }
    }
    
    @objc private func updateDataBoxes(_ notification: Notification) {
        guard let objectId = notification.object as? Int else { return }
        let pointData = data.filter({ $0.attributes.objectId == objectId })
        let confirmed = pointData.first!.attributes.confirmed
        let deaths = pointData.first!.attributes.deaths
        let recovered = pointData.first!.attributes.recovered
        let location = pointData.first?.attributes.provinceState ?? pointData.first?.attributes.countryRegion
        
        box1.countLabel.text = String(describing: confirmed)
        box2.countLabel.text = String(describing: deaths)
        box3.countLabel.text = String(describing: recovered)
        titleLabel.text = location
    }
}
