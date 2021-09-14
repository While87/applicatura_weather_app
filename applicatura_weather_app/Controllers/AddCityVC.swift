//
//  AddCityVC.swift
//  applicatura_weather_app
//
//  Created by Vladimir Gorbunov on 14.09.2021.
//

import UIKit

class AddCityVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var cityTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide empty cells
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    @IBAction func addPressed(_ sender: Any) {
        guard let _ = cityTextField.text else { return }
        self.view.endEditing(true)
        
        
        cityTextField.text = ""
    }
}
