//
//  EndpointType.swift
//  GaialiWeather
//
//  Created by Nemanja Ducic on 4/6/21.
//

import Foundation

protocol EndpointType {
    var baseURL: URL { get }
    var path: String { get }
}
