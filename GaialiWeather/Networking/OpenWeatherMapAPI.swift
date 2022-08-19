//
//  OpenWeatherMapAPI.swift
//  GaialiWeather
//
//  Created by Nikola Ticojevic on 4/3/21.
//

import Foundation
import RxSwift

class OpenWeatherMapApiService {
    private let networking = Networking()

    func getCityByGeographicCoordinates(latitude: String, longitude: String) -> Observable<WeatherResponse> {
        return networking.execute(url: URL(string: APIKeys.baseUrl + "/data/2.5/forecast?lat=\(latitude)&lon=\(longitude)&appid=\(APIKeys.appId)&units=metric")!)
    }
}
