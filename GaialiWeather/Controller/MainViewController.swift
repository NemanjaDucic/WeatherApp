//
//  ViewController.swift
//  GaialiWeather
//
//  Created by Nemanja Ducic on 4/6/21.
//

import UIKit
import RxSwift

class MainViewController: UIViewController, UISearchControllerDelegate {
    enum DateFormat: String {
        case fullDate = "EEEE, MMM d, yyyy"
        case hourMinute = "HH:mm"
    }

    private let defaultCity = "Munich"
    private var sliderPossition = 0
    private let cellIdentifier = "weatherCollectionViewCell"

    @IBOutlet weak var collectionView: UICollectionView!

    private let viewModel = MainViewControllerViewModel()
    private let disposeBag = DisposeBag()

    private var weatherResult: WeatherResult?
    private var weatherResults: [[List]]?

    private var cityList: [String] = []
    private var currentCityList: [String] = []

    private var resultController: UISearchController?
    private var cityListTableViewController: CityListTableViewController!

    //MARK: - ViewController LyfeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initialSetup()
    }

    //MARK: - IBActions

    @IBAction func sliderViewDidSlide(_ sender: UISlider) {
        sliderPossition = Int(sender.value)
        collectionView.reloadData()
    }


    //MARK: - Get Data From ViewModel

    private func getWeatherFromViewModelWith(cityName: String) {
        viewModel.weather
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                self?.weatherResult = result
                self?.chunkWeatherResult()
                self?.title = result.city.name
                self?.collectionView.reloadData()
                self?.view.hideLoadingIndicator()
                self?.resultController?.searchBar.text = nil
            }, onError: { error in
                print("onError: \(error)")
            })
            .disposed(by: disposeBag)
            viewModel.getCityBy(name: cityName)

    }

    private func getCityNameFromViewModel() {
        viewModel.cityList
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                self?.cityList = result
            }, onError: { error in
                print("onError: \(error)")
            })
            .disposed(by: disposeBag)
        viewModel.getCityList(fileName: "city.list")
        setupSearchTableController()
    }

    //MARK: - Setting up SearchController

    func setupSearchTableController() {
        cityListTableViewController = (storyboard?.instantiateViewController(withIdentifier: "cityListController") as! CityListTableViewController)
        cityListTableViewController.delegate = self
        cityListTableViewController.cityList = cityList
        resultController = UISearchController(searchResultsController: cityListTableViewController)
        resultController?.searchResultsUpdater = cityListTableViewController
        navigationItem.searchController = resultController
        resultController?.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
    }

    //MARK: - Helper Methods

    private func chunkWeatherResult() {
        guard let weather = weatherResult?.list else { return }
        let chunkSize = 8
        let chunks = stride(from: 0, to: weather.count, by: chunkSize).map {
            Array(weather[$0..<min($0 + chunkSize, weather.count)])
        }
        weatherResults = chunks
    }

    private func dateFormatter(date: Double, format: DateFormat) -> String {
        let date = Date(timeIntervalSince1970: date)
        let dateFormatter = DateFormatter()
        switch format {
        case .fullDate:
            dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        case .hourMinute:
            dateFormatter.dateFormat = "HH:mm"
        }
        let strDate = dateFormatter.string(from: date)

        return strDate
    }

    private func initialSetup() {
        collectionView.delegate = self
        collectionView.dataSource = self

        collectionView.isPagingEnabled = true
        collectionView.register(UINib(nibName: "WeatherCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: cellIdentifier)

        getCityNameFromViewModel()
        getWeatherFromViewModelWith(cityName: defaultCity)
        view.showLoadingIndicator()
    }
}

//MARK: - CollectionView dataSource and delegate

extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! WeatherCollectionViewCell

        var cellData: [List] = []
        cell.pageNumber.text = "page: \(indexPath.row + 1)/5"

        if let weather = weatherResults {
            switch indexPath.row {
            case 0:
                cellData = weather[0]
            case 1:
                cellData = weather[1]
            case 2:
                cellData = weather[2]
            case 3:
                cellData = weather[3]
            case 4:
                cellData = weather[4]
            default:
                break
            }

            let cellPoss = cellData[sliderPossition]
            cell.temperature.text = "\(Int(cellPoss.main.temp))" + "℃"
            cell.dateLabel.text = "\(dateFormatter(date: Double(cellPoss.dt), format: .fullDate))"
            cell.weatherLabel.text = "Weather: \(cellPoss.weather[0].main) "
            cell.weatherDescriptionLabel.text = "Weather description: \(cellPoss.weather[0].description)"
            cell.humidityLabel.text = "Humidity: \(cellPoss.main.humidity)%"
            cell.timeLabel.text = "Time: \(dateFormatter(date: Double(cellPoss.dt), format: .hourMinute))"

            if let cellWeather = cellPoss.weather.first {
                cell.weatherImageView.image = UIImage(named: cellWeather.icon)
            }
        }

        return cell
    }
}

//MARK: - CollectionView delegateFlowLayout

extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: collectionView.frame.width, height: collectionView.frame.height)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK: - CityList delegate

extension MainViewController: CityListTableViewDelegate {
    func passSelectedCity(_ name: String) {
        getWeatherFromViewModelWith(cityName: name)
    }
}
