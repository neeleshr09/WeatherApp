//
//  FavouriteTableViewCell.swift
//  WeatherApp
//
//  Created by Neelesh Rai on 31/05/21.
//  Copyright © 2021 Neelesh Rai. All rights reserved.
//

import Foundation
import UIKit


class FavouriteTableViewCell: UITableViewCell {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var weatherIndicatorIcon: UIImageView!
    @IBOutlet weak var dayTemperatureLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    /// Upate cell UI to display data
    /// - Parameter item: Current weather offline model
    func updateUI(item: CurrentWeatherOffline) {
        if let itemAtIndex = item.current, let cityName = itemAtIndex.weatherName {
            self.cityNameLabel.text = cityName
            if let weatherArr = itemAtIndex.weatherArray, let type = weatherArr[0].weatherMain {
                if type == "cloud".localized() || type == "mist".localized() {
                    self.weatherIndicatorIcon.image = WeatherImages.clear
                    self.backgroundColor = UIColor(hexString: Colors.cloudy)
                } else if type == "haze".localized() || type == "rain".localized() || type == "smoke".localized() || type == "drizzle".localized() {
                    self.weatherIndicatorIcon.image = WeatherImages.rain
                    self.backgroundColor = UIColor(hexString: Colors.rainy)
                } else {
                    self.weatherIndicatorIcon.image = WeatherImages.partlySunny
                    self.backgroundColor = UIColor(hexString: Colors.sunny)
                }
            }
            
            if let info = itemAtIndex.currentWeatheMain, let tempValue = info.mainTemp {
                self.dayTemperatureLabel.text = tempValue.convertToDegree()
            }
        }
    }
}

