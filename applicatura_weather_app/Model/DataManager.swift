//
//  DataManager.swift
//  applicatura_weather_app
//
//  Created by Vladimir Gorbunov on 15.09.2021.
//

import UIKit
import CoreData

class DataManager {
    
    var favoriteCities = [City]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    //MARK: - Data save/load methods
    
    func saveCities() {
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
}
