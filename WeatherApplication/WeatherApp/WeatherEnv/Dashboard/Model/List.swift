//
//  List.swift
//  WeatherApp
//
//  Created by Neelesh Rai on 30/05/21.
//  Copyright © 2021 Neelesh Rai. All rights reserved.
//

import Foundation

struct List : Codable, Hashable, Equatable {
    static func == (lhs: List, rhs: List) -> Bool {
        return lhs.dt == rhs.dt
    }
    
    private let dt : Int?
    private let main : Main?
    private let weather : [Weather]?
    private let clouds : Clouds?
    private let wind : Wind?
    private let sys : Sys?
    private let dt_txt : String?
    
    var hashValue: Int { get { return dt.hashValue } }
    
    enum CodingKeys: String, CodingKey {
        case dt = "dt"
        case main = "main"
        case weather = "weather"
        case clouds = "clouds"
        case wind = "wind"
        case sys = "sys"
        case dt_txt = "dt_txt"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        dt = try values.decodeIfPresent(Int.self, forKey: .dt)
        main = try values.decodeIfPresent(Main.self, forKey: .main)
        weather = try values.decodeIfPresent([Weather].self, forKey: .weather)
        clouds = try values.decodeIfPresent(Clouds.self, forKey: .clouds)
        wind = try values.decodeIfPresent(Wind.self, forKey: .wind)
        sys = try values.decodeIfPresent(Sys.self, forKey: .sys)
        dt_txt = try values.decodeIfPresent(String.self, forKey: .dt_txt)
    }
    
    var listDt: Int? {
        if let dt = self.dt {
            return dt
        }
        return 0
    }
    
    var listMain: Main? {
        if let main = self.main {
            return main
        }
        return nil
    }
    
    var listWeather: [Weather]? {
        if let weather = self.weather {
            return weather
        }
        return []
    }
}
