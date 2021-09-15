//
//  AddCityVC.swift
//  applicatura_weather_app
//
//  Created by Vladimir Gorbunov on 14.09.2021.
//

import UIKit

protocol AddVCDelegate {
    func updateViewData()
}

class AddCityVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityTextField: UITextField!
    
    var weatherManager = WeatherManager()
    var dataManager: DataManager?
    var delegate: AddVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateData()
        
        gestureRecognizer()
        
        weatherManager.delegate = self
        cityTextField.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //hide empty cells
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        delegate?.updateViewData()
        updateWeather()
    }
    
    func updateWeather() {
        guard let cities = dataManager?.getCitiesAsArray() else { return }
        weatherManager.getWeather(cities: cities)
    }
    
    func addFavoriteCity(name: String) {
        guard !(dataManager?.favoriteCities.contains(where: { $0.name == name }))! else {
            return
        }
        
        weatherManager.getNameOrCoordinates(lat: nil, lon: nil, name: name)
    }
    
    @objc func removeFavoriteCity (sender: AnyObject) {
        dataManager?.context.delete((dataManager?.favoriteCities[sender.tag])!)
        dataManager?.saveContext()
        
        updateData()
    }
    
    @IBAction func addPressed(_ sender: Any) {
        guard let city = cityTextField.text, cityTextField.text != "", cityTextField.text != nil else { return }
        
        addFavoriteCity(name: city)
        cityTextField.text = ""
        
        self.view.endEditing(true)
    }
    
    func updateData() {
        dataManager?.loadCities()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

//MARK: - Handling keyboard behavior

extension AddCityVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let city = cityTextField.text, cityTextField.text != "", cityTextField.text != nil else { return false}
        
        addFavoriteCity(name: city)
        cityTextField.text = ""
        self.view.endEditing(true)
        
        return true
    }
    
    func gestureRecognizer() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func hideKeyboard () {
        self.view.endEditing(true)
    }
}

//MARK: - TableView methods

extension AddCityVC: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (dataManager?.favoriteCities.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        let button = UIButton(type: .custom)
        button.setBackgroundImage(.remove, for: .normal)
        button.sizeToFit()
        button.addTarget(self, action: #selector(removeFavoriteCity(sender:)), for: .touchUpInside)
        
        cell.accessoryView = button
        cell.accessoryView?.tag = indexPath.row
        cell.selectionStyle = .none
        cell.textLabel?.text = dataManager?.favoriteCities[indexPath.row].name
        
        return cell
    }
}

//MARK: - WetherManager delegate methods

extension AddCityVC: WeatherManagerDelegate {
    
    func didGetCity(data: CityData) {
        dataManager?.addCity(city: data)
        
        updateWeather()
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func didGetWeather(data: WeatherData, city: City) {
        dataManager?.addWeather(weather: data, city: city)
    }
}
