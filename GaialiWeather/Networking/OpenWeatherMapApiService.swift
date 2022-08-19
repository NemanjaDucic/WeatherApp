//
//  OpenWeatherMapAPI.swift
//  GaialiWeather
//
//  Created by Nemanja Ducic on 4/6/21.
//

import Foundation
import RxSwift

class OpenWeatherMapApiService {
    private let networking = Networking()

    func getCityBy(name: String) -> Observable<WeatherResult> {
        let urlString = APIKeys.baseUrl + "/data/2.5/forecast?q=\(name)&appid=\(APIKeys.appId)&units=metric"
        let encoded = urlString.addingPercentEncoding(withAllowedCharacters: .urlFragmentAllowed)
        let url = URL(string: encoded!)

        return networking.execute(url: url!)
    }
}
