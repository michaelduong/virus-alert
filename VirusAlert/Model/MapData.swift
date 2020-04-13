//
//  MapData.swift
//  VirusAlert
//
//  Created by Swift Team Six on 2/17/20.
//  Copyright © 2020 Turnt Labs. All rights reserved.
//

import Foundation
import Arrow

struct MapData: Decodable {
    var features: [Feature] = []
}

struct Feature: Decodable {
    var attributes = Attribute()
}

struct Attribute: Decodable, Equatable, Comparable {
    var objectId: Int = 0
    var provinceState: String?
    var countryRegion: String = ""
    var confirmed: Int = 0
    var deaths: Int = 0
    var recovered: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case objectId = "OBJECTID"
        case provinceState = "Province_State"
        case countryRegion = "Country_Region"
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

extension MapData: ArrowParsable {
    mutating func deserialize(_ json: JSON) {
        features <-- json["features"]
    }
}

extension Feature: ArrowParsable {
    mutating func deserialize(_ json: JSON) {
        attributes <-- json["attributes"]
    }
}

extension Attribute: ArrowParsable {
    mutating func deserialize(_ json: JSON) {
        objectId <-- json["OBJECTID"]
        provinceState <-- json["Province_State"]
        countryRegion <-- json["Country_Region"]
        confirmed <-- json["Confirmed"]
        deaths <-- json["Deaths"]
        recovered <-- json["Recovered"]
    }
}
