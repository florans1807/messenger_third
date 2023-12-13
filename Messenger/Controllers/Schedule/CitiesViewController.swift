//
//  CitiesViewController.swift
//  Messenger
//
//  Created by Флоранс on 12.12.2023.
//

import UIKit
import CoreLocation
import JGProgressHUD

class CitiesViewController: UIViewController {
    
    private var spinner = JGProgressHUD(style: .dark)

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var directionLabel: UILabel!
    
    var stationInField: String?
    
    var countries: [Country] = []
    //var nearestStations: [Station2] = []
    //var dictOfStations: [String:[String]] = [:]
        
    var originalData: [SearchedStation] = []
    var filteredData: [SearchedStation] = []
    
    var originalDataNearest: [SearchedStation] = []
    var filteredDataNearest: [SearchedStation] = []
    
    //var sortedStations: [Station] = []
    //var stations: [Station] = []
    
    var isFrom = false
    
    var placeholder: String = ""
    
    var delegate: SetSelectedDirectionOrDate?
        
    lazy var locationManager: CLLocationManager = {
        var manager = CLLocationManager()
        manager.distanceFilter = 10
        manager.desiredAccuracy = kCLLocationAccuracyBest
        return manager
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.requestWhenInUseAuthorization()
        
        //getNearestStations()
        getAllStations()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
        
        if isFrom {
            directionLabel.text = "Откуда"
            searchBar.placeholder = "Откуда"
        } else {
            directionLabel.text = "Куда"
            searchBar.placeholder = "Куда"
        }
        
        searchBar.becomeFirstResponder()
        if let field = stationInField {
            searchBar.text = stationInField
        }
    }
    
    func getListOfStations() {
        for country in countries {
            for region in country.regions {
                for settlement in region.settlements {
                    for station in settlement.stations {
                        let stationId = UUID().uuidString
                        originalData.append(SearchedStation(id: stationId, name: station.title, code: station.codes.yandexCode, regionTitle: region.title, stationType: station.stationType))
                    }
                }
            }
        }
    }
    
//    func getListOfNearestStations() {
//        for station in nearestStations {
//            let stationId = UUID().uuidString
//            originalDataNearest.append(SearchedStation(id: stationId, name: station.title, code: station.code, regionTitle: station.shortTitle ?? "", stationType: station.stationType))
//        }
//    }
    
    func getAllStations() {
        ApiClient.shared.getAllStations { [weak self] values in
            DispatchQueue.main.async {
                guard let self else { return }
                self.countries = values
                self.getListOfStations()
                self.tableView.reloadData()
            }
        }
    }
    
//    func getNearestStations() {
//        ApiClient.shared.getNearestStations { [weak self] values in
//            DispatchQueue.main.async {
//                guard let self else { return }
//                self.nearestStations = values
//                self.getListOfNearestStations()
//                self.tableView.reloadData()
//            }
//        }
//    }
    
    @IBAction func closeStationsSearch(_ sender: Any) {
        dismissStationsSearchList()
    }
    
    func dismissStationsSearchList() {
        self.dismiss(animated: true)
        delegate?.resignTextFields()
    }
}

extension CitiesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if originalData.isEmpty {
            spinner.show(in: tableView)
        } else {
            spinner.dismiss()
        }
        if searchBar.text != "" {
            return filteredData.count
        }
        return originalData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "stationCell", for: indexPath) as! StationTableViewCell
        if searchBar.text != "" {
            //RETURN CELLS CREATED FROM FILTERED DATA
            let station = filteredData[indexPath.row]
            cell.stationLabel.text = station.name
            cell.regionLabel.text = station.stationType.rawValue + " " + station.regionTitle
            return cell
        }
        //RETURN CELLS CREATED FROM ORIGINAL DATA
        let station = originalData[indexPath.row]
        cell.stationLabel.text = station.name
        cell.regionLabel.text = station.stationType.rawValue + " " + station.regionTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if searchBar.text != "" {
            //HANDLE ROW SELECTION FROM FILTERED DATA
            delegate?.setDirection(direction: filteredData[indexPath.row].name, code: filteredData[indexPath.row].code, isFrom: isFrom)
            dismissStationsSearchList()

        } else {
            //HANDLE ROW SELECTION FROM ORIGINAL DATA
            delegate?.setDirection(direction: originalData[indexPath.row].name, code: originalData[indexPath.row].code, isFrom: isFrom)
            dismissStationsSearchList()

        }
    }
    
}

extension CitiesViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let searchString = searchBar.text
        filteredData = originalData.filter({ (item) -> Bool in
            let value: NSString = item.name as NSString
            return (value.range(of: searchString!, options: .caseInsensitive).location != NSNotFound)
        })
        tableView.reloadData()
    }

}

struct SearchedStation {
    let id: String
    let name: String
    let code: String
    let regionTitle: String
    let stationType: StationType
    
    init(id: String, name: String, code: String, regionTitle: String, stationType: StationType) {
        self.id = id
        self.name = name
        self.code = code
        self.regionTitle = regionTitle
        self.stationType = stationType
    }
}
