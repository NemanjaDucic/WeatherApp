//
//  WeatherCollectionViewCell.swift
//  GaialiWeather
//
//  Created by Nikola Ticojevic on 4/5/21.
//

import UIKit

class WeatherCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    @IBOutlet weak var temperature: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var pageNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
