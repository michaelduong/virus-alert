//
//  DetailStatsViewController.swift
//  VirusAlert
//
//  Created by Swift Team Six on 2/15/20.
//  Copyright © 2020 Turnt Labs. All rights reserved.
//

import UIKit
import Stevia
import ws
import Then
import Arrow

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
    
    private let cellId = "cellId"
    
    var tableView = UITableView(frame: .zero, style: .grouped)
    var stack: UIStackView!
    var data = [Feature]()
    
    var confirmed: Int!
    var deaths: Int!
    var recovered: Int!
    
    var confirmedTuple: [(Int,String)] = []
    var deathsTuple: [(Int,String)] = []
    var recoveredTuple: [(Int,String)] = []
    var shownTuple: [(Int,String)] = []
    var shownTupleHeader = ""
    
    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        loadGlobalData()
        fetchAndSortStats()
        setupNotifications()
    }
    
    // MARK: - UI Functions
    private func setupUI() {
        stack = UIStackView(arrangedSubviews: [box1.size(100), box2.size(100), box3.size(100)], axis: .horizontal, spacing: 16, alignment: .center, distribution: .equalSpacing)
        view.subviews([
            titleLabel,
            stack,
            tableView
        ])
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.backgroundColor = R.color.backgroundWhite()
        tableView.sectionFooterHeight = 0
        setupConstraints()
        setupGestureRecognizers()
    }
    
    private func setupConstraints() {
        titleLabel.top(20)
            .height(29)
            .centerHorizontally()
        stack.left(21)
            .right(21)
            
            .Top == titleLabel.Bottom + 13
        tableView.left(0).right(0).bottom(0).Top == stack.Bottom + 10
    }
    
    private func setupGestureRecognizers() {
        let infectedTap = UITapGestureRecognizer(target: self, action: #selector(showConfirmedData))
        box1.addGestureRecognizer(infectedTap)
        let deathTap = UITapGestureRecognizer(target: self, action: #selector(showDeathsData))
        box2.addGestureRecognizer(deathTap)
        let recoveredTap = UITapGestureRecognizer(target: self, action: #selector(showRecoveredData))
        box3.addGestureRecognizer(recoveredTap)
    }
    
    private func setupNotifications() {
        let nc = NotificationCenter.default
        nc.addObserver(self, selector: #selector(updateDataBoxes(_:)), name: Notification.Name(NotificationName.updateData), object: nil)
        nc.addObserver(self, selector: #selector(loadGlobalData), name: Notification.Name(NotificationName.globalData), object: nil)
    }
    
    // MARK: - Table View Network Call
    private func fetchAndSortStats() {
        WSApi.shared.fetchMapData(layerType: .country).then { results in
            self.data = results.features
        }.onError{ e in
            print(e)
        }.then(sortData)
            .finally(reloadData)
    }
    
    private func sortData() {
        for dataPoint in data {
            let country = dataPoint.attributes.countryRegion
            let confirmedAmount = dataPoint.attributes.confirmed
            let deathsAmount = dataPoint.attributes.deaths
            let recoveredAmount = dataPoint.attributes.recovered
            
            confirmedTuple.append((confirmedAmount, country))
            deathsTuple.append((deathsAmount, country))
            recoveredTuple.append((recoveredAmount, country))
        }
        
        confirmedTuple.sort(by: { $0.0 > $1.0 })
        confirmedTuple = (confirmedTuple.filter({ $0.0 > 0 }))
        deathsTuple.sort(by: { $0.0 > $1.0 })
        deathsTuple = (deathsTuple.filter({ $0.0 > 0 }))
        recoveredTuple.sort(by: { $0.0 > $1.0 })
        recoveredTuple = (recoveredTuple.filter({ $0.0 > 0 }))
        
        shownTuple = confirmedTuple
        shownTupleHeader = "Total Infected"
    }
    
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Actions
    @objc private func loadGlobalData() {
        WSApi.shared.fetchMapData(layerType: .region).then { results in
            self.data = results.features
        }.onError{ e in
            print(e)
        }.then(sortGlobalData)
            .finally(reloadDataBoxes)
    }
    
    private func sortGlobalData() {
        confirmed = 0
        deaths = 0
        recovered = 0
        self.data.forEach { dataPoint in
            confirmed += dataPoint.attributes.confirmed
            deaths += dataPoint.attributes.deaths
            recovered += dataPoint.attributes.recovered
        }
    }
    
    private func reloadDataBoxes() {
        DispatchQueue.main.async {
            self.box1.countLabel.text = String(describing: self.confirmed.withCommas())
            self.box2.countLabel.text = String(describing: self.deaths.withCommas())
            self.box3.countLabel.text = String(describing: self.recovered.withCommas())
            self.titleLabel.text = "Global Cases"
        }
    }
    
    @objc private func updateDataBoxes(_ notification: Notification) {
        guard let objectId = notification.object as? Int else { return }
        let pointData = data.filter({ $0.attributes.objectId == objectId })
        let confirmed = pointData.first!.attributes.confirmed
        let deaths = pointData.first!.attributes.deaths
        let recovered = pointData.first!.attributes.recovered
        let location = pointData.first?.attributes.provinceState ?? pointData.first?.attributes.countryRegion
        
        box1.countLabel.text = String(describing: confirmed.withCommas())
        box2.countLabel.text = String(describing: deaths.withCommas())
        box3.countLabel.text = String(describing: recovered.withCommas())
        titleLabel.text = location
    }
    
    @objc private func showConfirmedData() {
        shownTuple = confirmedTuple
        shownTupleHeader = "Total Infected"
        tableView.reloadData()
    }
    
    @objc private func showDeathsData() {
        shownTuple = deathsTuple
        shownTupleHeader = "Total Deaths"
        tableView.reloadData()
    }
    
    @objc private func showRecoveredData() {
        shownTuple = recoveredTuple
        shownTupleHeader = "Total Recovered"
        tableView.reloadData()
    }
}

// MARK: - UITableView Data Source Methods
extension DetailStatsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shownTuple.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.textColor = R.color.hospitalBlue()
        cell?.textLabel?.font = R.font.latoBold(size: 24)
        cell?.detailTextLabel?.textColor = R.color.slateBlack()
        cell?.detailTextLabel?.font = R.font.latoRegular(size: 18)
        
        var data: (Int, String)!
        
        data = shownTuple[indexPath.row]
        
        cell?.textLabel?.text = String(describing: data.0)
        cell?.detailTextLabel?.text = data.1
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableView Delegate Methods
extension DetailStatsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.font = R.font.latoBold(size: 16)
        label.textColor = R.color.slateBlack()
        view.addSubview(label)
        label.anchorCenterSuperview()
        
        label.text = shownTupleHeader
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}
