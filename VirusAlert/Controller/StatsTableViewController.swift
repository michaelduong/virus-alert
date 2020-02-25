//
//  StatsTableViewController.swift
//  VirusAlert
//
//  Created by Swift Team Six on 2/18/20.
//  Copyright © 2020 Turnt Labs. All rights reserved.
//

import UIKit
import Neon

final class StatsTableViewController: UITableViewController {
    
    // MARK: - Properties
    let titleView: UIView = {
        let view = UIView()
        view.backgroundColor = R.color.hospitalBlue()
        view.layer.cornerRadius = 16
        view.layer.opacity = 0.90
        view.addShadow(ofColor: .black, radius: 3, offset: .zero, opacity: 0.50)
        let label = UILabel()
        label.text = "Coronavirus 2019-nCoV"
        label.font = R.font.latoBoldItalic(size: 14)
        label.textAlignment = .center
        label.textColor = R.color.backgroundWhite()
        view.addSubview(label)
        label.anchorCenterSuperview()
        return view
    }()
    let changeViewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = R.color.hospitalBlue()
        button.layer.cornerRadius = 20
        button.layer.opacity = 0.90
        button.addShadow(ofColor: .black, radius: 3, offset: .zero, opacity: 0.50)
        button.setImageForAllStates(R.image.statsIcon()!)
        button.tintColor = R.color.backgroundWhite()
        button.addTarget(self, action: #selector(changeViewButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private let cellId = "cellId"
    
    var data: [Feature]!
    var confirmed = 0
    var deaths = 0
    var recovered = 0
    var confirmedTuple: [(Int,String)] = []
    var deathsTuple: [(Int,String)] = []
    var recoveredTuple: [(Int,String)] = []
    
    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchAndSortStats()
    }
    
    // MARK: - UI Functions
    private func setupUI() {
        tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.allowsSelection = false
        tableView.backgroundColor = R.color.backgroundWhite()
        tableView.contentInset = .init(top: 60, left: 0, bottom: 0, right: 0)
        tableView.sectionFooterHeight = 0
        
        tableView.addSubviews([
            titleView,
            changeViewButton
        ])
        titleView.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: nil, topConstant: 10, leftConstant: 0, bottomConstant: 0, rightConstant: 0, widthConstant: 220, heightConstant: 32)
        titleView.anchorCenterXToSuperview()
        changeViewButton.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: nil, bottom: nil, right: view.safeAreaLayoutGuide.rightAnchor, topConstant: 5, leftConstant: 0, bottomConstant: 0, rightConstant: 20, widthConstant: 40, heightConstant: 40)
    }
    
    private func fetchAndSortStats() {
        Service.shared.fetchMapJSONData(layerType: .country) { [weak self] (result, err) in
            if let err = err {
                print(err)
            }
            
            if let result = result {
                self?.data = result
                
                guard let data = self?.data else { return }
                for dataPoint in data {
                    let country = dataPoint.attributes.countryRegion
                    let confirmedAmount = dataPoint.attributes.confirmed
                    let deathsAmount = dataPoint.attributes.deaths
                    let recoveredAmount = dataPoint.attributes.recovered
                    
                    self?.confirmed += confirmedAmount
                    self?.deaths += deathsAmount
                    self?.recovered += recoveredAmount
                    
                    self?.confirmedTuple.append((confirmedAmount, country))
                    self?.deathsTuple.append((deathsAmount, country))
                    self?.recoveredTuple.append((recoveredAmount, country))
                }
            }
            self?.confirmedTuple.sort(by: { $0.0 > $1.0 })
            self?.confirmedTuple = (self?.confirmedTuple.filter({ $0.0 > 0 }))!
            self?.deathsTuple.sort(by: { $0.0 > $1.0 })
            self?.deathsTuple = (self?.deathsTuple.filter({ $0.0 > 0 }))!
            self?.recoveredTuple.sort(by: { $0.0 > $1.0 })
            self?.recoveredTuple = (self?.recoveredTuple.filter({ $0.0 > 0 }))!
            
            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Actions
    @objc private func changeViewButtonTapped() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType(rawValue: "flip")
        transition.subtype = CATransitionSubtype.fromLeft
        navigationController?.view.layer.add(transition, forKey: kCATransition)
        navigationController?.popViewController(animated: false)
    }
}

// MARK: - UITableView Data Source Methods
extension StatsTableViewController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return confirmedTuple.count
        case 1:
            return deathsTuple.count
        case 2:
            return recoveredTuple.count
        default:
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellId)
        
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellId)
        }
        
        cell?.textLabel?.textColor = R.color.hospitalBlue()
        cell?.textLabel?.font = R.font.latoBold(size: 24)
        cell?.detailTextLabel?.textColor = R.color.slateBlack()
        cell?.detailTextLabel?.font = R.font.latoRegular(size: 18)
        
        var data: (Int, String)!
        
        switch indexPath.section {
        case 0:
            data = confirmedTuple[indexPath.row]
        case 1:
            data = deathsTuple[indexPath.row]
        case 2:
            data = recoveredTuple[indexPath.row]
        default:
            break
        }
        
        cell?.textLabel?.text = String(describing: data.0)
        cell?.detailTextLabel?.text = data.1
        return cell ?? UITableViewCell()
    }
}

// MARK: - UITableView Delegate Methods
extension StatsTableViewController {
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.font = R.font.latoBlack(size: 16)
        label.textColor = R.color.slateBlack()
        view.addSubview(label)
        label.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, topConstant: 10, leftConstant: 16, bottomConstant: 10, rightConstant: 16, widthConstant: 0, heightConstant: 0)
        
        switch section {
        case 0:
            label.text = "TOTAL CONFIRMED" + " (" + String(describing: confirmed) + ")"
        case 1:
            label.text = "TOTAL DEATHS" + " (" + String(describing: deaths) + ")"
        case 2:
            label.text = "TOTAL RECOVERED" + " (" + String(describing: recovered) + ")"
        default:
            break
        }
        
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
