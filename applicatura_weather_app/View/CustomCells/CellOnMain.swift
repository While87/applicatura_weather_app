//
//  CellOnMain.swift
//  applicatura_weather_app
//
//  Created by Vladimir Gorbunov on 15.09.2021.
//

import UIKit

class CellOnMain: UITableViewCell {
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        
//        cityLabel.text = ""
//        tempLabel.text = ""
//        weatherImage.image = .none
//    }
}
