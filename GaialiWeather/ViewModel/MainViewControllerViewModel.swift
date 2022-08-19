//
//  MainViewControllerModel.swift
//  GaialiWeather
//
//  Created by Nemanja Ducic on 4/6/21.
//

import Foundation
import RxSwift

class MainViewControllerViewModel {
    private let apiService = OpenWeatherMapApiService()
    private let fileManagerService = FileManagerService()

    var weather = PublishSubject<WeatherResult>()
    var cityList = PublishSubject<[String]>()

    private let disposeBag = DisposeBag()

    public func getCityBy(name: String) {
        apiService.getCityBy(name: name)
            .subscribe(onNext: { [weak self] result in
                self?.weather.onNext(result)
            }, onError: { error in
                print("getCity onError: \(error)")
            })
            .disposed(by: disposeBag)
    }

    public func getCityList(fileName: String) {
        fileManagerService.getCityList(name: fileName)
            .subscribe(onNext: { [weak self] result in
                self?.cityList.onNext(result)
            }, onError: { error in
                print("cityListError onError: \(error)")
            })
            .disposed(by: disposeBag)
    }
 
}
