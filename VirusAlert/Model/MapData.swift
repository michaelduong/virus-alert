//
//  MapData.swift
//  VirusAlert
//
//  Created by Swift Team Six on 2/17/20.
//  Copyright © 2020 Turnt Labs. All rights reserved.
//

import Foundation

struct MapData: Decodable {
    let features: [Feature]
}

struct Feature: Decodable {
    let attributes: Attribute
}

struct Attribute: Decodable, Equatable, Comparable {
    let objectId: Int
    let provinceState: String?
    let countryRegion: String
    let lastUpdate: Int
    let confirmed: Int
    let deaths: Int
    let recovered: Int
    
    enum CodingKeys: String, CodingKey {
        case objectId = "OBJECTID"
        case provinceState = "Province_State"
        case countryRegion = "Country_Region"
        case lastUpdate = "Last_Update"
        case confirmed = "Confirmed"
        case deaths = "Deaths"
        case recovered = "Recovered"
    }
    
    static func < (lhs: Attribute, rhs: Attribute) -> Bool {
        return lhs.objectId < rhs.objectId
    }
    
    static func == (lhs: Attribute, rhs: Attribute) -> Bool {
        return lhs.objectId == rhs.objectId
    }
}
