//
//  CityListTableViewController.swift
//  GaialiWeather
//
//  Created by Nemanja Ducic on 4/6/21.
//

import UIKit

protocol CityListTableViewDelegate {
    func passSelectedCity(_ name: String)
}

class CityListTableViewController: UITableViewController {
    private let cellIdentifier = "cityListCellIdentifier"

    var cityList: [String] = []
    var delegate: CityListTableViewDelegate!

    private var filteredCityList: [String] = []

    //MARK: - ViewController LyfeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
    }
}

//MARK: - TableView dataSource and delegate

extension CityListTableViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCityList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)

        cell.textLabel?.text = filteredCityList[indexPath.row]
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedCity = filteredCityList[indexPath.row]
        delegate.passSelectedCity(selectedCity)
        self.dismiss(animated: true, completion: nil)
    }
}

//MARK: - SearchResults delegate

extension CityListTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        if let inputText = searchController.searchBar.text, !inputText.isEmpty {
            filteredCityList = cityList.filter({ (text) -> Bool in
                return text.contains(inputText)
            })
        }

        tableView.reloadData()
    }
}
