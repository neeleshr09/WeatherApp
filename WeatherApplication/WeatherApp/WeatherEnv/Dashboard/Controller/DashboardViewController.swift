//
//  DashboardViewController.swift
//  WeatherApp
//
//  Created by Neelesh Rai on 30/05/21.
//  Copyright © 2021 Neelesh Rai. All rights reserved.
//

import Foundation
import UIKit

class DashboardViewController: UIViewController {
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherStateLabel: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var currentTemperatureLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnFavourite: UIButton!
    @IBOutlet weak var lastUpdatedTime: UILabel!
    
    private lazy var viewModel = DashboardViewModel(view: self)
    private var displayItemsArray = [List]()
    private let toast = Toast()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.checkInternetConnectivity()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    /// Reload action to get currnet location and display data
    @IBAction func reloadAction(_ sender: Any) {
        viewModel.checkInternetConnectivity()
    }
    
    /// Favourite action to make the current weather favourite
    @IBAction func favouriteAction(_ sender: Any) {
        viewModel.updateFavourite()
    }
    
    /// Favourite list action to display all the favourite list
    @IBAction func favouriteListAction(_ sender: Any) {
        viewModel.moveToFavouriteList()
    }
    
    /// Map action to display all the favourite pins of the map
    @IBAction func mapAction(_ sender: Any) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let mapVC = storyBoard.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController else {
            return
        }
        self.navigationController?.pushViewController(mapVC, animated: true)
    }
}


//MARK:- Tableview delegate and datasource
extension DashboardViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.displayItemsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? DashboardTableViewCell else {
            return UITableViewCell()
        }
        
        let item = self.displayItemsArray[indexPath.row]
        cell.updateUI(item: item)
        return cell
    }
}

//MARK:- Dashboard view delegate methods
extension DashboardViewController: DashboardView {
    
    func showLoader() {
        ProgressIndicator.sharedInstance.showWithBlurView()
    }
    
    func dismissLoader() {
        ProgressIndicator.sharedInstance.hide()
    }
    
    func reloadTableView() {
        self.tableView.reloadData()
    }
    
    func setCityName(name: String) {
        self.cityNameLabel.text = name
    }
    
    func weatherState(state: String) {
        self.weatherStateLabel.text = state
    }
    
    func setMinimumTemperature(temp: String) {
        self.minTemperatureLabel.text = temp
    }
    
    func setMaximumTemperature(temp: String) {
        self.maxTemperatureLabel.text = temp
    }
    
    func setCurrentTemperature(temp: String) {
        self.currentTemperatureLabel.text = temp
        self.temperatureLabel.text = temp
    }
    
    func setLastUpdatedTime(time: String) {
        self.lastUpdatedTime.text = time
    }
    
    func changeTheme(state: WeatherState) {
        switch state {
        case .cloudy:
            self.weatherImage.image = WeatherImages.forestCloudy
            self.tableView.backgroundColor = UIColor(hexString: Colors.cloudy)
            self.headerView.backgroundColor = UIColor(hexString: Colors.cloudy)
            
        case .rainy:
            self.weatherImage.image = WeatherImages.forestRainy
            self.tableView.backgroundColor = UIColor(hexString: Colors.rainy)
            self.headerView.backgroundColor = UIColor(hexString: Colors.rainy)
            
        case .sunny:
            self.weatherImage.image = WeatherImages.forestSunny
            self.tableView.backgroundColor = UIColor(hexString: Colors.sunny)
            self.headerView.backgroundColor = UIColor(hexString: Colors.sunny)
        }
    }
    
    func updateForcaseData(list: [List]) {
        self.displayItemsArray = list
    }
    
    func setFavouriteUnfevouriteImage(image: UIImage?) {
        self.btnFavourite.setImage(image, for: .normal)
    }
    
    func showToast(message: String) {
        toast.showToast(message: message)
    }
    
    func navigateToFavouriteList(data: [CurrentWeatherOffline]) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let favouriteVC = storyBoard.instantiateViewController(withIdentifier: "FavouriteViewController") as? FavouriteViewController else {
            return
        }
        favouriteVC.delegate = self
        favouriteVC.favouriteList = data
        self.navigationController?.pushViewController(favouriteVC, animated: true)
    }

}

extension DashboardViewController: FavouriteViewDelegate {
    func didSelectedFavouriteData(data: CurrentWeatherOffline) {
        viewModel.reloadViewWithOfflineData(weatherData: data)
    }
}
