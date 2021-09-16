//
//  DetailVC.swift
//  applicatura_weather_app
//
//  Created by Vladimir Gorbunov on 14.09.2021.
//

import UIKit

class DetailVC: UIViewController {

    var city: String?
    var weather: [Weather_daily]?
    var dataManager: DataManager?
    
    @IBOutlet weak var cityName: UILabel?
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cityName?.text = city
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UINib(nibName: "CellOnDetail", bundle: nil), forCellReuseIdentifier: "CellOnDetail")
        tableView.tableFooterView = UIView(frame: .zero)
    }
}

//MARK: - TableView methods

extension DetailVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weather?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellOnDetail") as! CellOnDetail
        let dayWeather = weather?[indexPath.row]
        
        let dayTemp = dataManager!.signStringTemp(int: Int(dayWeather!.temp_day))
        let nightTemp = dataManager!.signStringTemp(int: Int(dayWeather!.temp_night))
        
        cell.dateLabel?.text = weather?[indexPath.row].date
        cell.tempLabel?.text = "\(dayTemp) / \(nightTemp) ºC"
        cell.humidityLabel?.text = String(format: "Влажность %.0f", dayWeather?.humidity as! CVarArg) + " %"
        cell.windLabel?.text = String(format: "Ветер %.0f", dayWeather?.wind_speed as! CVarArg) + " м/с"
        cell.condition = Int((dayWeather?.weather_id)!)
        
        return cell
    }
}
