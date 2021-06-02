//
//  WeatherAPIClient.swift
//  WeatherApp
//
//  Created by Neelesh Rai on 30/05/21.
//  Copyright © 2021 Neelesh Rai. All rights reserved.
//

import Foundation

class WeatherAPIClient {
    typealias CurrentWeatherCompletionHandler = (CurrentWeather?, Error?) -> Void
    typealias ForecastWeatherCompletionHandler = (ForecastWeatherResponse?, Error?) -> Void
    
    private let apiKey = "fae7190d7e6433ec3a45285ffcf55c86"
    //"b3e8da6dc891d50580ecc4c39eecb744"
    private let decoder = JSONDecoder()
    private let session: URLSession
    
    private enum SuffixURL: String {
        case forecastWeather = "forecast"
        case currentWeather = "weather"
    }
    
    private func baseUrl(_ suffixURL: SuffixURL, lat: Double, long: Double) -> URL {
        return URL(string: "https://api.openweathermap.org/data/2.5/\(suffixURL.rawValue)?lat=\(lat)&lon=\(long)&APPID=\(self.apiKey)")!
    }
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    private func getBaseRequest<T: Codable>(at lat: Double,
                                            long: Double,
                                            suffixURL: SuffixURL,
                                            completionHandler completion:  @escaping (_ object: T?,_ error: Error?) -> ()) {
        
        let url = baseUrl(suffixURL, lat: 25.4484, long: 78.5685)
//        let url = baseUrl(suffixURL, lat: lat, long: long)
        let request = URLRequest(url: url)
        print("URL - \(url)")
        let task = session.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    guard let httpResponse = response as? HTTPURLResponse else {
                        completion(nil, ResponseError.requestFailed)
                        return
                    }
                    
                    if httpResponse.statusCode == 200 {
                        do {
                            let weather = try self.decoder.decode(T.self, from: data)
                            completion(weather, nil)
                        } catch let error {
                            completion(nil, error)
                        }
                    } else {
                        completion(nil, ResponseError.invalidData)
                    }
                } else if let error = error {
                    completion(nil, error)
                }
            }
        }
        
        task.resume()
    }
    
    func getCurrentWeather(lat: Double, long: Double, completionHandler completion: @escaping CurrentWeatherCompletionHandler) {
        getBaseRequest(at: lat, long: long, suffixURL: .currentWeather) { (weather: CurrentWeather?, error) in
            completion(weather, error)
        }
    }
    
    func getForecastWeather(lat: Double, long: Double, completionHandler completion: @escaping ForecastWeatherCompletionHandler) {
        getBaseRequest(at: lat, long: long, suffixURL: .forecastWeather) { (weather: ForecastWeatherResponse?, error) in
            completion(weather, error)
        }
    }
}
