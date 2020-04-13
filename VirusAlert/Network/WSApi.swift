//
//  WSApi.swift
//  VirusAlert
//
//  Created by Swift Team Six on 4/12/20.
//  Copyright © 2020 Turnt Labs. All rights reserved.
//

import ws
import Then

final class WSApi {
    static let shared = WSApi()
    private let ws = WS("")
    private var regionEndpoint: String!
    
    private init() {
//        ws.logLevels = .debug
    }
       
    func fetchMapData(layerType: Layer) -> Promise<MapData> {
        switch layerType {
        case .country:
            regionEndpoint = "https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/ncov_cases/FeatureServer/2/query?f=json&where=1%3D1&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=OBJECTID%20ASC&resultOffset=0&resultRecordCount=10000&cacheHint=true&quantizationParameters=%7B%22mode%22%3A%22edit%22%7D"
        case .region:
            regionEndpoint = "https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/ncov_cases/FeatureServer/1/query?f=json&where=1%3D1&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=OBJECTID%20ASC&resultOffset=0&resultRecordCount=10000&cacheHint=true&quantizationParameters=%7B%22mode%22%3A%22edit%22%7D"
        }
        
        return ws.get(regionEndpoint)
    }
    
    func fetchNewsArticles() -> Promise<[NewsArticles]> {
        return ws.get("https://storage.googleapis.com/coronavirus-news/news.json")
    }
    
    func fetchTips() -> Promise<[Tips]> {
        return ws.get("https://coronareader.com/data.json")
    }
}
