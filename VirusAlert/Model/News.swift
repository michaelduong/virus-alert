//
//  News.swift
//  VirusAlert
//
//  Created by Swift Team Six on 4/10/20.
//  Copyright © 2020 Turnt Labs. All rights reserved.
//

import Foundation
import Arrow

struct News: Codable {
    let title: String
    let description: String
    let imageUrl: String
    let url: String
    let date: String
    let source: Source
    var author: String {
        return source.name
    }
    
    enum CodingKeys: String, CodingKey {
        case source, title, url, description
        case imageUrl = "urlToImage"
        case date = "publishedAt"
    }
}

struct Source: Codable {
    var name = ""
}

struct NewsArticles {
    var title = ""
    var description = ""
    var imageUrl = ""
    var url = ""
    var date = "" {
        didSet {
            date = convertDate(date: date)
        }
    }
    
    func convertDate(date: String) -> String {
        let isoDateFormatter = ISO8601DateFormatter()
        isoDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        isoDateFormatter.formatOptions = [
            .withFullDate,
            .withFullTime,
            .withDashSeparatorInDate
        ]
        
        let convertedDate = isoDateFormatter.date(from: date)
        
        return convertedDate?.dateString(ofStyle: .medium) ?? ""
    }
}

extension NewsArticles: ArrowParsable {
    mutating func deserialize(_ json: JSON) {
        title <-- json["title"]
        description <-- json["description"]
        imageUrl <-- json["urlToImage"]
        url <-- json["url"]
        date <-- json["publishedAt"]
    }
}
