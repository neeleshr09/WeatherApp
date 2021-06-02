//
//  Main.swift
//  WeatherApp
//
//  Created by Neelesh Rai on 30/05/21.
//  Copyright © 2021 Neelesh Rai. All rights reserved.
//

import Foundation

struct Main : Codable {
    private let temp : Double?
    private let pressure : Int?
    private let humidity : Int?
    private let temp_min : Double?
    private let temp_max : Double?
    private let sea_level : Int?
    private let grnd_level : Int?
    private let temp_kf : Double?
    
    enum CodingKeys: String, CodingKey {
        case temp = "temp"
        case pressure = "pressure"
        case humidity = "humidity"
        case temp_min = "temp_min"
        case temp_max = "temp_max"
        case sea_level = "sea_level"
        case grnd_level = "grnd_level"
        case temp_kf = "temp_kf"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        temp = try values.decodeIfPresent(Double.self, forKey: .temp)
        pressure = try values.decodeIfPresent(Int.self, forKey: .pressure)
        humidity = try values.decodeIfPresent(Int.self, forKey: .humidity)
        temp_min = try values.decodeIfPresent(Double.self, forKey: .temp_min)
        temp_max = try values.decodeIfPresent(Double.self, forKey: .temp_max)
        sea_level = try values.decodeIfPresent(Int.self, forKey: .sea_level)
        grnd_level = try values.decodeIfPresent(Int.self, forKey: .grnd_level)
        temp_kf = try values.decodeIfPresent(Double.self, forKey: .temp_kf)
    }
    
    var minTemperature: String {
        if let minTempValue = temp_min {
            return  minTempValue.convertToDegree()
        }
        return ""
    }
    
    var maxTemperature: String {
        if let maxTempValue = temp_max {
            return maxTempValue.convertToDegree()
        }
        return ""
    }
    
    var currentTemperature: String {
        if let currentTempValue = temp {
            return currentTempValue.convertToDegree()
        }
        return ""
    }
    
    var mainTemp: Double? {
        return temp
    }
}
