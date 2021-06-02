//
//  CurrentWeatherOffline.swift
//  WeatherApp
//
//  Created by Neelesh Rai on 30/05/21.
//  Copyright © 2021 Neelesh Rai. All rights reserved.
//

import Foundation

struct CurrentWeatherOffline: Codable {
    var current: CurrentWeather?
    var forecast: ForecastWeatherResponse?
    var isFav: Bool?
    var latitude: Double?
    var longitude: Double?
    
    init(withCurrent current: CurrentWeather?, withForecast forecast: ForecastWeatherResponse?, withFav isFav: Bool?, latitude: Double?, longitude: Double) {
        self.current = current
        self.forecast = forecast
        self.isFav = isFav
        self.latitude = latitude
        self.longitude = longitude
    }
    
    mutating func setFavourite(value: Bool) {
        self.isFav = value
    }
    
    mutating func setCurrentWeather(value: CurrentWeather) {
        self.current = value
    }
    
    mutating func setLatLong(lat: Double, long: Double) {
        self.latitude = lat
        self.longitude = long
    }
}
