//
//  WeatherManager.swift
//  applicatura_weather_app
//
//  Created by Vladimir Gorbunov on 14.09.2021.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didGetCityName (name: String)
}



class WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    private let APIKey = "57d18d415f683670998585db51c375d6"
    
    
    
    
    //MARK: - Getting city name by coordinats
    
    func getCityName(lat: CLLocationDegrees, long: CLLocationDegrees) {
        
        let cityURL = "https://api.openweathermap.org/geo/1.0/reverse?lat=\(lat)&lon=\(long)&limit=1&appid=\(APIKey)"
        
        guard let url = URL(string: cityURL) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            guard let data = data, error == nil else { return }
            
            do {
                let city = try JSONDecoder().decode([CityData].self, from: data)
                
                self.delegate?.didGetCityName(name: city[0].name)
                
            } catch {
                print(error)
            }
            
        }.resume()
    }
    
}
