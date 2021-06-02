//
//  UserDefault.swift
//  WeatherApp
//
//  Created by Neelesh Rai on 31/05/21.
//  Copyright © 2021 Neelesh Rai. All rights reserved.
//

import Foundation

class UserDefault {
    
    /// Set favourite list
    /// - Parameter model: Offline model object
    static func setFavouriteList(model: [CurrentWeatherOffline]) {
        let encoder = JSONEncoder()
        if let encodedData = try? encoder.encode(model) {
            UserDefaults.standard.set(encodedData, forKey: "FavouriteItems")
        }
        UserDefaults.standard.synchronize()

    }
    
    /// Get favourite list
    /// - Returns: Offline model object
    static func getFavouriteList() -> [CurrentWeatherOffline] {
        if let favouriteData = UserDefaults.standard.object(forKey: "FavouriteItems") as? Data {
            let decoder = JSONDecoder()
            if let offlineData = try? decoder.decode([CurrentWeatherOffline].self, from: favouriteData) {
                return offlineData
            }
        }
        return []
    }
}
