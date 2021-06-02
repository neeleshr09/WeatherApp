//
//  DashboardTableViewCell.swift
//  WeatherApp
//
//  Created by Neelesh Rai on 30/05/21.
//  Copyright © 2021 Neelesh Rai. All rights reserved.
//

import Foundation
import UIKit

class DashboardTableViewCell: UITableViewCell {
    
    @IBOutlet weak var dayNameLabel: UILabel!
    @IBOutlet weak var weatherIndicatorIcon: UIImageView!
    @IBOutlet weak var dayTemperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// Upate cell UI to display data
    /// - Parameter item: list model
    func updateUI(item: List) {
        if let epoach = item.listDt {
            let date = Utility.convertEpochTimeToActualTime(epochTime: Double(epoach))
            let day = date.components(separatedBy: ",")
            if day.count > 0 { self.dayNameLabel.text = day[0] }
        }
        
        if let weatherArr = item.listWeather, let type = weatherArr[0].weatherMain {
            if type == "cloud".localized() || type == "mist".localized() {
                self.weatherIndicatorIcon.image = WeatherImages.clear
            } else if type == "haze".localized() || type == "rain".localized() || type == "smoke".localized() || type == "drizzle".localized() {
                self.weatherIndicatorIcon.image = WeatherImages.rain
            } else {
                self.weatherIndicatorIcon.image = WeatherImages.partlySunny
            }
        }
        
        if let info = item.listMain, let tempValue = info.mainTemp {
            self.dayTemperatureLabel.text = tempValue.convertToDegree()
        }
    }
}
