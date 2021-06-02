//
//  FavouriteViewController.swift
//  WeatherApp
//
//  Created by Neelesh Rai on 31/05/21.
//  Copyright © 2021 Neelesh Rai. All rights reserved.
//

import Foundation
import UIKit

protocol FavouriteViewDelegate {
    func didSelectedFavouriteData(data: CurrentWeatherOffline)
}

class FavouriteViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var favouriteList = [CurrentWeatherOffline]()
    var delegate: FavouriteViewDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.tableFooterView = UIView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = false
    }
}

//MARK:- Tableview delegate method
extension FavouriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.favouriteList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? FavouriteTableViewCell else {
            return UITableViewCell()
        }
        
        let item = self.favouriteList[indexPath.row]
        cell.updateUI(item: item)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let favouriteData = self.favouriteList[indexPath.row]
        if let delegate = self.delegate {
            delegate.didSelectedFavouriteData(data: favouriteData)
            self.navigationController?.popViewController(animated: true)
        }
    }
}

