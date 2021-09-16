//
//  CellOnMain.swift
//  applicatura_weather_app
//
//  Created by Vladimir Gorbunov on 15.09.2021.
//

import UIKit

class CellOnMain: UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel?
    @IBOutlet weak var tempLabel: UILabel?
    @IBOutlet weak var weatherImage: UIImageView?
    
    var condition: Int?
    var imageName: String {
        guard let id = condition else { return "questionmark" }
        switch id {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "sun.max"
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        cityLabel?.text = nil
        tempLabel?.text = nil
        weatherImage?.image = UIImage(systemName: imageName)
    }
}
