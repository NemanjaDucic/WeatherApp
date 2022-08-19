//
//  List.swift
//  GaialiWeather
//
//  Created by Nemanja Ducic on 4/6/21.
//

import Foundation

struct List: Codable {
    let dt: Int
    let main: Main
    let weather: [Weather]
}
