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
    
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var favoriteCities = [City]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let locationManager = CLLocationManager()
    let weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.requestLocation()
        
        weatherManager.delegate = self
        
        loadFavoriteCities()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //hide empty cells
        tableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    //MARK: - Data save/load methods
    
    func saveCities() {
        
        do {
            try context.save()
        } catch {
            print("Error saving data - \(error)")
        }
        
    }
    
    func loadFavoriteCities() {
        
        let request : NSFetchRequest<City> = City.fetchRequest()
        
        do{
            favoriteCities = try context.fetch(request)
        } catch {
            print("Error loading cities \(error)")
        }
        
        tableView.reloadData()
        
    }
    
    //MARK: - Add favorite city button pressed
    
    @IBAction func addCityPressed(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let addVC = storyboard.instantiateViewController(withIdentifier: "addCity") as! AddCityVC
        addVC.modalPresentationStyle = .automatic
        
        addVC.delegate = self
        
        present(addVC, animated: true)
        
    }
}

//MARK: - TableView methods

extension MainVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favoriteCities.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = favoriteCities[indexPath.row].name
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let detailVC = storyboard.instantiateViewController(withIdentifier: "detail") as! DetailVC
        
        detailVC.modalPresentationStyle = .automatic
        
        detailVC.city = favoriteCities[indexPath.row].name
        
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
            
            let lat = location.coordinate.latitude
            let long = location.coordinate.longitude
            
            weatherManager.getCityName(lat: lat, long: long)
            
        }
    }
}

//MARK: - WetherManager delegate methods

extension MainVC: WeatherManagerDelegate {
    
    func didGetCityName(name: String) {
        
        guard !favoriteCities.contains(where: { $0.name == name }) else {
            return
        }
        
        let current = City(context: self.context)
        current.name = name
        
        self.favoriteCities.append(current)
        
        self.saveCities()
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            
        }
    }
}

//MARK: - AddVCDelegate delegate method

extension MainVC: AddVCDelegate {
    
    func updateView() {
        
        loadFavoriteCities()
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            
        }
    }
}
