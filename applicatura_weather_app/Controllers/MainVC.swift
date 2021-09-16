//
//  MainVC.swift
//  applicatura_weather_app
//
//  Created by Vladimir Gorbunov on 14.09.2021.
//

import UIKit
import CoreData
import CoreLocation

class MainVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    let locationManager = CLLocationManager()
    let dataManager = DataManager() //CoreData manager
    let weatherManager = WeatherManager() //Weather JSON data manager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        dataManager.delegate = self
        
        updateViewData() //get data and update tableView
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //hide empty cells
        tableView.tableFooterView = UIView(frame: .zero)
        
        tableView.register(UINib(nibName: "CellOnMain", bundle: nil), forCellReuseIdentifier: "CellOnMain")
    }
    
    func updateWeather() {
        let cities = dataManager.getCitiesAsArray()
        weatherManager.getWeather(cities: cities)
    }
    
    //MARK: - Add favorite city button pressed
    
    @IBAction func addCityPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let addVC = storyboard.instantiateViewController(withIdentifier: "addCity") as! AddCityVC
        addVC.modalPresentationStyle = .automatic
        
        addVC.delegate = self
        addVC.dataManager = self.dataManager
        
        present(addVC, animated: true)
        
    }
}

//MARK: - TableView methods

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.favoriteCities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let currentDate = dataManager.dateToString()
        let city = dataManager.favoriteCities[indexPath.row]
        dataManager.loadWeatherCurrent(for: city)
        let weather = dataManager.weatherCurent.first(where: { $0.date == currentDate })
        
        let cell: CellOnMain = tableView.dequeueReusableCell (withIdentifier: "CellOnMain") as! CellOnMain
        
        if weather != nil {
            cell.cityLabel?.text = city.name
            cell.tempLabel?.text = dataManager.signStringTemp(int: Int(weather!.temp)) + " ºC"
            cell.condition = Int(weather!.weather_id)
    }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let detailVC = storyboard.instantiateViewController(withIdentifier: "detail") as! DetailVC
        detailVC.modalPresentationStyle = .automatic
        
        let city = dataManager.favoriteCities[indexPath.row]
        dataManager.loadWeatherDaily(for: city)
        
        detailVC.city = city.name
        detailVC.weather = dataManager.weatherDaily
        detailVC.dataManager = self.dataManager
        
        present(detailVC, animated: true)
    }
}

//MARK: - LocationManager delegate methods

extension MainVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            locationManager.stopUpdatingLocation()
            
            let lat = String(location.coordinate.latitude)
            let lon = String(location.coordinate.longitude)
            
            weatherManager.getNameOrCoordinates(lat: lat, lon: lon, name: nil)
        }
    }
}

//MARK: - WetherManager delegate methods

extension MainVC: WeatherManagerDelegate {
    
    func didGetCity(data: CityData) {
        dataManager.addCity(city: data)

        updateWeather()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didGetWeather(data: WeatherData, city: City) {
        dataManager.addWeather(weather: data, city: city)
        updateViewData()
    }
}

//MARK: - AddVCDelegate delegate method

extension MainVC: AddVCDelegate {
    
    func updateViewData() {
        dataManager.loadCities()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

    //MARK: - DataManagerDelegate method

extension MainVC: DatamanagerDelegate {
    func didGetWeather() {
        tableView.reloadData()
    }
}
