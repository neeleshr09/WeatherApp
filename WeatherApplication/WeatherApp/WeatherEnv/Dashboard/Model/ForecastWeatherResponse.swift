//
//  ForecastWeatherResponse.swift
//  WeatherApp
//
//  Created by Neelesh Rai on 30/05/21.
//  Copyright © 2021 Neelesh Rai. All rights reserved.
//

import Foundation

struct ForecastWeatherResponse : Codable {
    private let cod : String?
    private let message : Int?
    private let cnt : Int?
    private let list : [List]?
    private let city : City?
    
    enum CodingKeys: String, CodingKey {
        case cod = "cod"
        case message = "message"
        case cnt = "cnt"
        case list = "list"
        case city = "city"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        cod = try values.decodeIfPresent(String.self, forKey: .cod)
        message = try values.decodeIfPresent(Int.self, forKey: .message)
        cnt = try values.decodeIfPresent(Int.self, forKey: .cnt)
        list = try values.decodeIfPresent([List].self, forKey: .list)
        city = try values.decodeIfPresent(City.self, forKey: .city)
    }
    
    //MARK:-  Update UI according to next five days weather API response
    func configureForecastDetails() -> [List] {
        var forecastItems =  [List]()
        var dateAtIndex: Date? = nil
        if let itemsArray = self.list {
            //Need to iterate because there is more than one entry for the same day(for every 3 hours)
            for item in itemsArray {
                if let epochTime = item.listDt {
                    if dateAtIndex == nil {
                        dateAtIndex = Utility.convertEpochTimeToActualDate(epochTime: Double(epochTime))
                        let cal = Calendar.current.compare(dateAtIndex!, to: Date(), toGranularity: Calendar.Component.day)
                        if cal == .orderedDescending {
                            forecastItems.append(item)
                        }
                    } else {
                        let loopDate = Utility.convertEpochTimeToActualDate(epochTime: Double(epochTime))
                        if let date = dateAtIndex {
                            let cal = Calendar.current.compare(date, to: loopDate, toGranularity: Calendar.Component.day)
                            if cal == .orderedAscending {
                                dateAtIndex = nil
                            }
                        }
                    }
                }
            }
            return forecastItems
        }
        return []
    }
}
