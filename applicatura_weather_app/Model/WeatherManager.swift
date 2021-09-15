//
//  WeatherManager.swift
//  applicatura_weather_app
//
//  Created by Vladimir Gorbunov on 14.09.2021.
//

import Foundation

protocol WeatherManagerDelegate {
    func didGetData (name: String, lat: String, lon: String)
}

class WeatherManager {
    
    var delegate: WeatherManagerDelegate?
    
    private let APIKey = "57d18d415f683670998585db51c375d6"
    
    
    
    
    //MARK: - Getting city name or coordinates
    
    func getNameOrCoordinates(lat: String?, lon: String?, name: String?) {
        var url: String
        
        if name == nil && lat != nil && lon != nil {
            url = "https://api.openweathermap.org/geo/1.0/reverse?lat=\(lat!)&lon=\(lon!)&limit=1&appid=\(APIKey)"
        } else {
            let site = "https://api.openweathermap.org/geo/1.0/direct?q=\(name!)&limit=1&appid=\(APIKey)"
            //Checking to whitespaces in name like "Saint Petersburg"
            url = site.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        }
        
        guard let url = URL(string: url) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            
            guard let data = data, error == nil else { return }
            
            do {
                let city = try JSONDecoder().decode([CityData].self, from: data)
                
                let name = String(city[0].name)
                let lat = String(city[0].lat)
                let lon = String(city[0].lon)
                
                self.delegate?.didGetData(name: name, lat: lat, lon: lon)
                
            } catch {
                print(error)
            }
            
        }.resume()
    }
    
    //MARK: - Getting weather
    
    func getWeather(lat: String, long: String) {
//        let weatherURL = "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(long)&exclude=minutely,hourly,alerts&units=metric&appid=57d18d415f683670998585db51c375d6"
    }
}
