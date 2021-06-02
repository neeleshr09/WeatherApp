//
//  DashboardView.swift
//  WeatherApp
//
//  Created by Neelesh Rai on 30/05/21.
//  Copyright © 2021 Neelesh Rai. All rights reserved.
//

import Foundation
import UIKit

protocol DashboardView: AnyObject {
    func showLoader()
    func dismissLoader()
    func reloadTableView()
    func setCityName(name: String)
    func weatherState(state: String)
    func setMinimumTemperature(temp: String)
    func setMaximumTemperature(temp: String)
    func setCurrentTemperature(temp: String)
    func setLastUpdatedTime(time: String)
    func changeTheme(state: WeatherState)
    func updateForcaseData(list: [List])
    func setFavouriteUnfevouriteImage(image: UIImage?)
    func showToast(message: String)
    func navigateToFavouriteList(data: [CurrentWeatherOffline])
}
