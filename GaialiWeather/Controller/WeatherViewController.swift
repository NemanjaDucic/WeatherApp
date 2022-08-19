//
//  WeatherViewController.swift
//  GaialiWeather
//
//  Created by Nikola Ticojevic on 4/4/21.
//

import Foundation
import UIKit
import RxSwift

class WeatherCollectionViewController: UICollectionViewController {

    private let viewModel = MainViewControllerViewModel()
    private let disposeBag = DisposeBag()

    private var weatherResult: WeatherResponse?
    var mainIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib(nibName: "WeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "weatherCollectionViewCell")
        setupViewModel()
    }
    private func setupViewModel() {
        self.viewModel.weather
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] list in
                self?.weatherResult = list
                self?.collectionView.reloadData()
            }, onError: { error in
                print("onError: \(error)")
            })
            .disposed(by: disposeBag)
        viewModel.getCityByGeographicCoordinates(latitude: "41.557", longitude: "-8.406")
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "weatherCollectionViewCell", for: indexPath) as! WeatherCollectionViewCell

        return cell
    }
}
