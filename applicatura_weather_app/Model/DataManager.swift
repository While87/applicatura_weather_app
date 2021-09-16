//
//  DataManager.swift
//  applicatura_weather_app
//
//  Created by Vladimir Gorbunov on 15.09.2021.
//

import UIKit
import CoreData

protocol DatamanagerDelegate {
    
    func didGetWeather()
}


class DataManager {
    
    var delegate: DatamanagerDelegate?
    
    var favoriteCities = [City]()
    var weatherCurent = [Weather_current]()
    var weatherDaily = [Weather_daily]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    //MARK: - Data save/load methods
    
    func saveContext() {
        
        do {
            try context.save()
        } catch {
            print("Error saving data - \(error)")
        }
    }
    
    func loadCities() {
        let request : NSFetchRequest<City> = City.fetchRequest()
        
        do{
            favoriteCities = try context.fetch(request)
        } catch {
            print("Error loading cities \(error)")
        }
    }
    
    func addCity(city: CityData) {
        guard !favoriteCities.contains(where: { $0.name == city.name }) else { return }
        
        let newCity = City(context: context)
        newCity.name = city.name
        newCity.lat = city.lat
        newCity.lon = city.lon
        
        favoriteCities.append(newCity)
        saveContext()
    }
    
    func getCitiesAsArray() -> [City] {
        let data = favoriteCities as Array
        return data
    }
    
    
    //MARK: - Weather add/load methods
    
    func addWeather(weather: WeatherData, city: City) {
        
        print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        loadWeatherCurrent(for: city)
        
        let newCurrent = Weather_current(context: context)
        
        //fetch current data
        let date = roundDayFormat(unixTime: weather.current.dt)
        newCurrent.date = date
        newCurrent.temp = Int16(weather.current.temp)
        newCurrent.weather_id = weather.current.weather[0].id
        newCurrent.parentCity = city
        
        //checking of unique record
        if let index = weatherCurent.firstIndex(where: {$0.date == date}) {
            context.delete(weatherCurent[index])
            weatherCurent.append(newCurrent)
        } else {
            weatherCurent.append(newCurrent)
        }
        
        saveContext()
        
        //fetch daily data
        for element in weather.daily {
            
            loadWeatherDaily(for: city)
            
            let newDaily = Weather_daily(context: context)
            
            let date = roundDayFormat(unixTime: element.dt)
            
            newDaily.date = date
            newDaily.humidity = element.humidity
            newDaily.temp_day = element.temp.day
            newDaily.temp_night = element.temp.night
            newDaily.weather_id = element.weather[0].id
            newDaily.wind_speed = element.wind_speed
            newDaily.parentCity = city
            
            //checking of unique record
            if let index = weatherDaily.firstIndex(where: { $0.date == date}) {
                context.delete(weatherDaily[index])
                weatherDaily.append(newDaily)
            } else {
                weatherDaily.append(newDaily)
            }
            saveContext()
        }
    }
    
    func loadWeatherCurrent(for city: City) {
        let request: NSFetchRequest<Weather_current> = Weather_current.fetchRequest()
        let cityPredicate = NSPredicate(format: "parentCity.name MATCHES %@", city.name!)
        request.predicate = cityPredicate
        
        do {
            weatherCurent = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    func loadWeatherDaily(for city: City) {
        let request: NSFetchRequest<Weather_daily> = Weather_daily.fetchRequest()
        let cityPredicate = NSPredicate(format: "parentCity.name MATCHES %@", city.name!)
        request.predicate = cityPredicate
        
        do {
            weatherDaily = try context.fetch(request)
        } catch {
            print("Error fetching data from context \(error)")
        }
    }
    
    //MARK: - Utility methods
    
    func roundDayFormat(unixTime: Date) -> String {
        let longDate = Date(timeIntervalSince1970: unixTime.timeIntervalSinceReferenceDate)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        //formatter.timeZone = TimeZone.current
        let stringDate = formatter.string(from: longDate)
        return stringDate
    }
    
    func dateToString() -> String {
        let now = Date()
        let longDate = Date(timeIntervalSince1970: now.timeIntervalSince1970)
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let date = formatter.string(from: longDate)
        return date
        
    }
    
    func signStringTemp(int: Int) -> String {
        let result: String
        if int > 0 {
            result = "+\(int)"
        } else if int == 0 {
            result = "\(int)"
        } else {
            result = "-\(int)"
        }
        return result
    }
}
