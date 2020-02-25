//
//  Service.swift
//  VirusAlert
//
//  Created by Swift Team Six on 2/17/20.
//  Copyright © 2020 Turnt Labs. All rights reserved.
//

import Foundation
import ZippyJSON

class Service {
    
    static let shared = Service()
    
    private init() {}
    
    var arcGISJSONUrl: String!
    
    func fetchMapJSONData(layerType: Layer, completion: @escaping ([Feature]?, Error?) -> ()) {
        switch layerType {
        case .country:
            arcGISJSONUrl = "https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/ncov_cases/FeatureServer/2/query?f=json&where=1%3D1&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=OBJECTID%20ASC&resultOffset=0&resultRecordCount=80&cacheHint=true&quantizationParameters=%7B%22mode%22%3A%22edit%22%7D"
        case .region:
            arcGISJSONUrl = "https://services1.arcgis.com/0MSEUqKaxRlEPj5g/arcgis/rest/services/ncov_cases/FeatureServer/1/query?f=json&where=1%3D1&returnGeometry=false&spatialRel=esriSpatialRelIntersects&outFields=*&orderByFields=OBJECTID%20ASC&resultOffset=0&resultRecordCount=80&cacheHint=true&quantizationParameters=%7B%22mode%22%3A%22edit%22%7D"
        default:
            break
        }
                
        guard let url = URL(string: arcGISJSONUrl) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
            if let err = err {
                print(err.localizedDescription)
                completion(nil, err)
                return
            }
            
            do {
                let decoder = ZippyJSONDecoder()
                guard let data = data else {
                    print("No data")
                    completion(nil, nil)
                    return
                }
                let mapData = try decoder.decode(MapData.self, from: data)
                completion(mapData.features, nil)
            } catch {
                print("Failed to decode:", error)
                completion(nil, error)
            }
        }.resume()
    }
}

enum Layer {
    case country
    case region
}
