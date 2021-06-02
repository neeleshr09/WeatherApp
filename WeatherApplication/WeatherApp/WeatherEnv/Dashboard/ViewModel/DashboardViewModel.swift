//
//  DashboardViewModel.swift
//  WeatherApp
//
//  Created by Neelesh Rai on 30/05/21.
//  Copyright © 2021 Neelesh Rai. All rights reserved.
//

import Foundation
import CoreLocation

class DashboardViewModel {
    private weak var view: DashboardView?
       private let client = WeatherAPIClient()
       var currentWeather: CurrentWeather?
       var forecastWeather: ForecastWeatherResponse?
       var favouriteItemsArray = [CurrentWeatherOffline]()
       var getLatitude: Double = 0.0
       var getLongitude: Double = 0.0
       var locationAccess: Bool = true
    
    /// Initialize view and array
    /// - Parameter view: Dashbaord view
    init(view: DashboardView) {
        self.view = view
        self.favouriteItemsArray = UserDefault.getFavouriteList()
    }
    
    /// Fetch updated current location and API call
    @objc func fetchLocationAndAPICall() {
        self.getLatitude = LocationManager.sharedInstance.locationCoordinate.latitude
        self.getLongitude = LocationManager.sharedInstance.locationCoordinate.longitude
        self.getAPIData()
    }
    
    /// Get weather and forecast data from the API
    private func getAPIData() {
        view?.showLoader()
        
        client.getCurrentWeather(lat: self.getLatitude, long: self.getLongitude) { [weak self] currentWeather, error in
            guard let currentWeather = currentWeather else { return }
            self?.currentWeather = currentWeather
        }
        
        client.getForecastWeather(lat: self.getLatitude, long: self.getLongitude) { [weak self] forecastWeatherResponse, error in
            guard let forecastWeatherResponse = forecastWeatherResponse else { return }
            self?.view?.dismissLoader()
            self?.forecastWeather = forecastWeatherResponse
            self?.updateView()
        }
    }
    
    /// Set weather data to dispaly on the UI
    func setWeatherData() {
        view?.setCityName(name: self.currentWeather?.weatherName ?? "")
        view?.setMinimumTemperature(temp: self.currentWeather?.currentWeatheMain?.minTemperature ?? "")
        view?.setMaximumTemperature(temp: self.currentWeather?.currentWeatheMain?.maxTemperature ?? "")
        view?.setCurrentTemperature(temp: self.currentWeather?.currentWeatheMain?.currentTemperature ?? "")
        view?.weatherState(state: self.currentWeather?.weatherType ?? "")
        setWeatherState(type: self.currentWeather?.weatherType ?? "")
    }
    
    /// Set weather state to dispaly UI accordingly
    /// - Parameter type: state type
    func setWeatherState(type: String) {
        var state: WeatherState = .sunny
        if type == "cloud".localized() || type == "mist".localized() {
            state = .cloudy
        } else if type == "haze".localized() || type == "rain".localized() || type == "smoke".localized() || type == "drizzle".localized() {
            state = .rainy
        } else {
            state = .sunny
        }
        view?.changeTheme(state: state)
    }
    
    /// Set the forecast data to dispaly on the UI
       func setForecastData() {
           if let forecast = self.forecastWeather {
               view?.updateForcaseData(list: forecast.configureForecastDetails())
               view?.reloadTableView()
           }
       }
       
       /// Current weather favourite & unfavourite logic
       func updateFavourite() {
           let globalObject = CurrentWeatherOffline(withCurrent: self.currentWeather, withForecast: self.forecastWeather, withFav: false, latitude: self.getLatitude, longitude: self.getLongitude)
           
           if self.favouriteItemsArray.count > 0 {
               if let currentObject = globalObject.current, self.favouriteItemsArray.contains(where: { (item) -> Bool in
                   if item.current?.weatherName == currentObject.weatherName, let isFavourite = item.isFav {
                       if isFavourite {
                           self.favouriteItemsArray.removeAll(where: { (object) -> Bool in
                               if let objCityName = object.current?.weatherName, objCityName == item.current?.weatherName {
                                   var object = object
                                   object.setFavourite(value: false)
                                   view?.setFavouriteUnfevouriteImage(image: WeatherImages.unFavourite)
                                   view?.showToast(message: "unFavourite.message".localized())
                                   return true
                               }
                               return false
                           })
                       } else if let isFavourite = item.isFav, !isFavourite {
                           var object = item
                           object.setCurrentWeather(value: currentObject)
                           addFavouriteObjectInArray(object: object)
                           return true
                       }
                       return true
                   }
                   return false
               }) { } else {
                   //Called when doesn't match with existing object in offline model
                   addFavouriteObjectInArray(object: globalObject)
               }
           } else {
               //Called when array is empty
               guard let _ = self.currentWeather, let _ = self.forecastWeather else {
                   view?.showToast(message: "invalid.data.message".localized())
                   return
               }
               addFavouriteObjectInArray(object: globalObject)
           }
           
           UserDefault.setFavouriteList(model: self.favouriteItemsArray)
       }
    
    /// Add current weather object in the favourite array
    /// - Parameter object: Current weather object
    func addFavouriteObjectInArray(object: CurrentWeatherOffline) {
        var globalObject = object
        view?.setFavouriteUnfevouriteImage(image: WeatherImages.favourite)
        view?.showToast(message: "favourite.message".localized())
        globalObject.setFavourite(value: true)
        globalObject.setLatLong(lat: self.getLatitude, long: self.getLongitude)
        self.favouriteItemsArray.append(globalObject)
    }
    
    /// Navigate to favourite list
    func moveToFavouriteList() {
        if self.favouriteItemsArray.count > 0 {
            view?.navigateToFavouriteList(data: self.favouriteItemsArray)
        }else {
            view?.showToast(message: "list.empty.message".localized())
        }
    }
    
    /// Update favourite & unfavourite image according to data present in the favourite array
    func updateFavouriteImage() {
        _ = self.favouriteItemsArray.contains(where: { (item) -> Bool in
            if let itemWeatherName = item.current?.weatherName, let currentWeatherName = self.currentWeather?.weatherName {
                if itemWeatherName != currentWeatherName {
                    view?.setFavouriteUnfevouriteImage(image: WeatherImages.unFavourite)
                } else {
                    view?.setFavouriteUnfevouriteImage(image: WeatherImages.favourite)
                    return true
                }
            }
            return false
        })
    }
    
    /// Check for Location access status
    func checkLocationAccessStatus() -> Bool {
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            locationAccess = true
        case .restricted:
            locationAccess = true
        case .denied:
            locationAccess = true
        case .authorizedAlways:
            locationAccess = false
        case .authorizedWhenInUse:
            locationAccess = false
        @unknown default: break
        }
        return locationAccess
    }
    
    /// Location manager notification callback method
    /// - Parameter notification: Notification object
    @objc func handleLocationManagerSelector(withNotification notification : NSNotification) {
        let checkAccess = checkLocationAccessStatus()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: "location.access.notification".localized()), object: nil)
        if !checkAccess {
            fetchLocationAndAPICall()
        }
    }
    
    /// Check internet connectivity and call API or update UI based on saved favourite list
    func checkInternetConnectivity() {
        if !Reachability.isConnectedToNetwork() {
            if self.favouriteItemsArray.count > 0, let lastWeather = self.favouriteItemsArray.last {
                reloadViewWithOfflineData(weatherData: lastWeather)
                view?.showToast(message:  "offline.data.display.message".localized())
                return
            }
            view?.showToast(message:  "internet.unavailable.message".localized())
        }else {
            addLocationNotificationObsever()
        }
    }
    
    /// Add notification observer for notifying the location changes
    func addLocationNotificationObsever() {
        let checkAccess = checkLocationAccessStatus()
        if checkAccess {
            NotificationCenter.default.addObserver(self, selector: #selector(handleLocationManagerSelector(withNotification:)), name: NSNotification.Name(rawValue: "location.access.notification".localized()), object: nil)
            view?.showToast(message: "location.access.message".localized())
        }else {
            fetchLocationAndAPICall()
        }
    }
    
    /// Display the last updated time for API call
    func lastUpdatedTime() {
        view?.setLastUpdatedTime(time: self.currentWeather?.lastUpdatedTime ?? "")
    }
    
    /// Update UI
    func updateView() {
        self.setWeatherData()
        self.setForecastData()
        self.updateFavouriteImage()
        self.lastUpdatedTime()
    }
    
    /// Reload data in offline mode
    /// - Parameter weatherData: Offline weather object
    func reloadViewWithOfflineData(weatherData: CurrentWeatherOffline) {
        self.currentWeather = weatherData.current
        self.forecastWeather = weatherData.forecast
        self.updateView()
    }
}
