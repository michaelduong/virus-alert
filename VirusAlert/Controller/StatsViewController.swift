//
//  StatsViewController.swift
//  VirusAlert
//
//  Created by Swift Team Six on 2/10/20.
//  Copyright © 2020 Turnt Labs. All rights reserved.
//

import UIKit
import ArcGIS
import Neon
import FloatingPanel
import SwifterSwift

final class StatsViewController: UIViewController {
    
    // MARK: - Properties
    let mapView = AGSMapView()
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
        button.setImageForAllStates(R.image.chartIcon()!)
        button.addTarget(self, action: #selector(changeViewButtonTapped), for: .touchUpInside)
        return button
    }()
    let detailStatsVC = DetailStatsViewController()
    
    var fpc: FloatingPanelController!
    private var featureLayer: AGSFeatureLayer?
    weak var activeSelectionQuery: AGSCancelable?
    
    // MARK: - View Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - UI Functions
    private func setupUI() {
        view.addSubviews([
            mapView,
            titleView,
            changeViewButton
        ])
        setupConstraints()
        setupMap()
        setupFloatingPanel()
    }
    
    private func setupFloatingPanel() {
        fpc = FloatingPanelController()
        fpc.delegate = self
        fpc.surfaceView.backgroundColor = R.color.backgroundWhite()
        fpc.set(contentViewController: detailStatsVC)
        fpc.addPanel(toParent: self)
    }
    
    private func setupConstraints() {
        mapView.fillSuperview()
        titleView.anchorToEdge(.top, padding: 52, width: 220, height: 32)
        changeViewButton.anchorInCorner(.topRight, xPad: 20, yPad: 48, width: 40, height: 40)
    }
    
    private func setupMap() {
        let map = AGSMap()
        map.basemap = AGSBasemap.lightGrayCanvas()
        
        guard let featureServiceURL = URL(string: "https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/ncov_cases/FeatureServer/1") else { return }
        let featureTable = AGSServiceFeatureTable(url: featureServiceURL)
        let featureLayer = AGSFeatureLayer(featureTable: featureTable)
        self.featureLayer = featureLayer
        map.operationalLayers.add(featureLayer)
        
        mapView.map = map
        mapView.wrapAroundMode = .enabledWhenSupported
        mapView.touchDelegate = self
        mapView.selectionProperties.color = R.color.hospitalBlue()!
        
        mapView.locationDisplay.start { (error) in
            guard error == nil else {
                UIAlertController(title: "Error", message: error?.localizedDescription, defaultActionButtonTitle: "Ok")
                return
            }
            print("Location display started")
            self.mapView.locationDisplay.autoPanMode = .recenter
            self.mapView.locationDisplay.wanderExtentFactor = 0.75
            self.mapView.locationDisplay.initialZoomScale = 10000000
        }
    }
    
    // MARK: - Actions
    @objc private func changeViewButtonTapped() {
        
    }
}

extension StatsViewController: AGSGeoViewTouchDelegate {
    func geoView(_ geoView: AGSGeoView, didTapAtScreenPoint screenPoint: CGPoint, mapPoint: AGSPoint) {
        //cancel the active query if it hasn't been completed yet
        if let activeSelectionQuery = activeSelectionQuery {
            activeSelectionQuery.cancel()
        }
        
        guard let map = mapView.map,
            let featureLayer = featureLayer else {
                return
        }
        
        //tolerance level
        let toleranceInPoints: Double = 12
        //use tolerance to compute the envelope for query
        let toleranceInMapUnits = toleranceInPoints * mapView.unitsPerPoint
        let envelope = AGSEnvelope(xMin: mapPoint.x - toleranceInMapUnits,
                                   yMin: mapPoint.y - toleranceInMapUnits,
                                   xMax: mapPoint.x + toleranceInMapUnits,
                                   yMax: mapPoint.y + toleranceInMapUnits,
                                   spatialReference: map.spatialReference)
        
        //create query parameters object
        let queryParams = AGSQueryParameters()
        queryParams.geometry = envelope
        
        //run the selection query
        activeSelectionQuery = featureLayer.selectFeatures(withQuery: queryParams, mode: .new) { [weak self] (queryResult: AGSFeatureQueryResult?, error: Error?) in
            if let error = error {
                print(error.localizedDescription)
            }
            if let result = queryResult {
                print("\(result.featureEnumerator().allObjects.count) feature(s) selected")
                print(result.featureEnumerator().allObjects.first?.attributes)
            }
        }
    }
    
}

// MARK: - Floating Panel Controller Delegate Methods
extension StatsViewController: FloatingPanelControllerDelegate {
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return FloatingPanelStatsLayout()
    }
    
    func floatingPanel(_ vc: FloatingPanelController, behaviorFor newCollection: UITraitCollection) -> FloatingPanelBehavior? {
        return FloatingPanelStatsBehavior()
    }
    
    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
        
    }
    
    func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {
        
    }
}
