//
//  MapViewModel.swift
//  WeatherApp
//
//  Created by Neelesh Rai on 31/05/21.
//  Copyright © 2021 Neelesh Rai. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class MapViewModel {
    
    private weak var view: MapView?
    var favouriteArray = [CurrentWeatherOffline]()
    
    /// Initialize view and array
    /// - Parameter view: Dashbaord view
    init(view: MapView, data: [CurrentWeatherOffline]) {
        self.view = view
        self.favouriteArray = data
    }
    
    /// Configure annotations from the data array
    func configureAnnotations() {
        for object in favouriteArray {
            let annotation = MKPointAnnotation()
            annotation.title = object.current?.weatherName
            annotation.coordinate = CLLocationCoordinate2D(latitude: object.latitude ?? 0.0, longitude: object.longitude ?? 0.0)
            view?.addAnnotations(annotation: annotation)
        }
        view?.zoomMapToFitAnnotation()
    }
}
