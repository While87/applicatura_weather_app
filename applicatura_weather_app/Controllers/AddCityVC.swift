//
//  AddCityVC.swift
//  applicatura_weather_app
//
//  Created by Vladimir Gorbunov on 14.09.2021.
//

import UIKit
import CoreData

protocol AddVCDelegate {
    
    func updateView ()
    
}

class AddCityVC: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityTextField: UITextField!
    
    var favoriteCities = [Favorite]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var delegate: AddVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gestureRecognizer()
        
        loadFavoriteCities()
        
        cityTextField.delegate = self
        
        tableView.dataSource = self
        tableView.delegate = self
        
        //hide empty cells
        tableView.tableFooterView = UIView(frame: .zero)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        
        delegate?.updateView()
    }
    
    //MARK: - Data save/load methods
    
    func saveFavoriteCities() {
        
        do {
            try context.save()
        } catch {
            print("Error saving data - \(error)")
        }
        
        DispatchQueue.main.async {
            
            self.tableView.reloadData()
            
        }
    }
    
    func loadFavoriteCities() {
        
        let request : NSFetchRequest<Favorite> = Favorite.fetchRequest()
        
        do{
            favoriteCities = try context.fetch(request)
        } catch {
            print("Error loading cities \(error)")
        }
        
    }
    
    func addFavoriteCity(name: String) {
        
        guard !favoriteCities.contains(where: { $0.city == name }) else {
            return
        }
        
        let newCity = Favorite(context: self.context)
        
        newCity.city = name
        
        self.favoriteCities.append(newCity)
        
        self.saveFavoriteCities()

    }
    
    @objc func removeFavoriteCity (sender: AnyObject) {
       
        context.delete(favoriteCities[sender.tag])
        
        self.saveFavoriteCities()
        
        loadFavoriteCities()
        
    }
    
    @IBAction func addPressed(_ sender: Any) {
        
        guard let city = cityTextField.text, cityTextField.text != "", cityTextField.text != nil else { return }
        
        addFavoriteCity(name: city)
        
        cityTextField.text = ""
        
        self.view.endEditing(true)
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
        
        return favoriteCities.count
        
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
        
        cell.textLabel?.text = favoriteCities[indexPath.row].city
        
        return cell
        
    }
}
