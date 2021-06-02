//
//  MapView.swift
//  WeatherApp
//
//  Created by Neelesh Rai on 31/05/21.
//  Copyright © 2021 Neelesh Rai. All rights reserved.
//

import Foundation
import MapKit

protocol MapView: AnyObject {
    func addAnnotations(annotation: MKPointAnnotation)
    func zoomMapToFitAnnotation()
}
