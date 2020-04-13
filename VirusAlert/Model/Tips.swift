//
//  Tips.swift
//  VirusAlert
//
//  Created by Swift Team Six on 4/10/20.
//  Copyright © 2020 Turnt Labs. All rights reserved.
//

import Foundation
import Arrow

struct Tips {
    var title = ""
    var url = ""
    var image = ""
}

extension Tips: ArrowParsable {
    mutating func deserialize(_ json: JSON) {
        title <-- json["Title"]
        url <-- json["Link"]
        image <-- json["Image"]
    }
}
