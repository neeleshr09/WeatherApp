//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Neelesh Rai on 30/05/21.
//  Copyright © 2021 Neelesh Rai. All rights reserved.
//

import Foundation

struct CurrentWeather: Codable {
    private let weather : [Weather]?
    private let base : String?
    private let main : Main?
    private let visibility : Int?
    private let wind : Wind?
    private let dt : Int?
    private let sys : Sys?
    private let timezone : Int?
    private let id : Int?
    private let name : String?
    private let cod : Int?
    
    enum CodingKeys: String, CodingKey {
        case weather = "weather"
        case base = "base"
        case main = "main"
        case visibility = "visibility"
        case wind = "wind"
        case dt = "dt"
        case sys = "sys"
        case timezone = "timezone"
        case id = "id"
        case name = "name"
        case cod = "cod"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        weather = try values.decodeIfPresent([Weather].self, forKey: .weather)
        base = try values.decodeIfPresent(String.self, forKey: .base)
        main = try values.decodeIfPresent(Main.self, forKey: .main)
        visibility = try values.decodeIfPresent(Int.self, forKey: .visibility)
        wind = try values.decodeIfPresent(Wind.self, forKey: .wind)
        dt = try values.decodeIfPresent(Int.self, forKey: .dt)
        sys = try values.decodeIfPresent(Sys.self, forKey: .sys)
        timezone = try values.decodeIfPresent(Int.self, forKey: .timezone)
        id = try values.decodeIfPresent(Int.self, forKey: .id)
        name = try values.decodeIfPresent(String.self, forKey: .name)
        cod = try values.decodeIfPresent(Int.self, forKey: .cod)
    }
    
    var weatherType: String {
        if let infoArr = self.weather, let status = infoArr[0].weatherMain {
            return status
        }
        return ""
    }
    
    var lastUpdatedTime: String {
        if let epochTime = dt {
            return "Last Updated: \(Utility.convertEpochTimeToDate(epochTime: Double(epochTime)))"
        }
        return ""
    }
    
    var weatherName: String? {
        if let name = self.name {
            return name
        }
        return ""
    }
    
    var currentWeatheMain: Main? {
        if let main = self.main {
            return main
        }
        return nil
    }
    
    var weatherArray: [Weather]? {
        if let weather = self.weather {
            return weather
        }
        return []
    }
}
