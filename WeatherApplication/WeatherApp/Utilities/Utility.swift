//
//  Utility.swift
//  WeatherApp
//
//  Created by Neelesh Rai on 30/05/21.
//  Copyright © 2021 Neelesh Rai. All rights reserved.
//

import Foundation
import UIKit

class Utility {
    
    //Convert Epoch time to actual time
    static func convertEpochTimeToActualTime(epochTime: Double) -> String {
        let date = Date(timeIntervalSince1970: epochTime)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.full //Set date style
        dateFormatter.timeZone = .current
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
    
    //Convert Epoch time to Date time Format
    static func convertEpochTimeToActualDate(epochTime: Double) -> Date {
        let date = Date(timeIntervalSince1970: epochTime)
        return date
    }
    
    static func convertEpochTimeToDate(epochTime: Double) -> String {
        let date = Date(timeIntervalSince1970: epochTime)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM-dd-YYYY, hh:mm a"
        let localDate = dateFormatter.string(from: date)
        return localDate
    }
}
