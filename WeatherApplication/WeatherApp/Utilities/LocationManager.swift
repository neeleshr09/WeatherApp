//
//  LocationManager.swift
//  WeatherApp
//
//  Created by Neelesh Rai on 30/05/21.
//  Copyright © 2021 Neelesh Rai. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    var locationManager    = CLLocationManager()
    var locationCoordinate = CLLocationCoordinate2D()
    var onFetchComplete: ((CLLocationCoordinate2D?, Error?) -> ())?
    
    // MARK: Shared Instance
    class  var sharedInstance: LocationManager
    {
        struct Singleton
        {
            static let instance = LocationManager()
        }
        return Singleton.instance
    }
    
    func initLocationManager()
    {
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error)
    {
        if let callback = self.onFetchComplete {
            callback(nil, error)
            self.onFetchComplete = nil
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        let userLocation:CLLocation = locations[0] as CLLocation
        self.locationCoordinate = userLocation.coordinate
        manager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        var shouldAllow = false
        switch status {
        case CLAuthorizationStatus.restricted:
            print("Restricted Access to location")
        case CLAuthorizationStatus.denied:
            print("User denied access to location")
        case CLAuthorizationStatus.notDetermined:
            print("Status not determined")
        default:
            print("Allowed to location Access")
            shouldAllow = true
        }
        
        if (shouldAllow == true) {
            NSLog("Location to Allowed")
            // Start location services
            NotificationCenter.default.post(name: Notification.Name(rawValue: "location.access.notification".localized()), object: status)
            locationManager.startUpdatingLocation()
        }
    }
}
