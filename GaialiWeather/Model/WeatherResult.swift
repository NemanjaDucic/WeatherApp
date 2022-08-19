//
//  Weather.swift
//  GaialiWeather
//
//  Created by Nemanja Ducic on 4/6/21.
//

import Foundation

struct WeatherResult: Codable {
    let list: [List]
    let city: City
}
