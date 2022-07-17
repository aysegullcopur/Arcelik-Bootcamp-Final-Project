//
//  StationSelectionViewController.swift
//  Charger
//
//  Created by Aysegul COPUR on 15.07.2022.
//

import UIKit
import CoreLocation

class StationSelectionViewController: UIViewController {
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var stationSelectionTableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var provinceLabel: UILabel!
    @IBOutlet weak var stationListInfoLabel: UILabel!
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let locationManager = CLLocationManager()
    var latitude: Double?
    var longitude: Double?
    
    
    var province: String = ""
    private var stations = [APIAllStationModel]()
    
    private var selectedStations = [APIAllStationModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        stationSelectionTableView.dataSource = self
        stationSelectionTableView.delegate = self
        locationManager.delegate = self
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor.lightGray
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        activityIndicator.startAnimating()
        locationManager.requestLocation()
        mainStackView.isHidden = true
    }
    
    private func fetchStations() {
        guard let userId = UserDefaultsLogin.userId else {
            return
        }
        
        activityIndicator.startAnimating()
        
        API.getStations(userId: userId, latitude: longitude, longitude: latitude) { [self] result in
            switch result {
            case .success(let stationList):
                self.stations = stationList.filter { $0.geoLocation.province == self.province}
                self.provinceLabel.text = "'\(self.province)'"
                self.stationListInfoLabel.text = String(localized: "stationsListInfo").replacingOccurrences(of: "<<0>>", with: String(self.stations.count))
                
                self.mainStackView.isHidden = false
                self.stationSelectionTableView.reloadData()
            case .failure(_):
                self.presentAlert(title: String(localized: "genericErrorMessage"))
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func presentAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: String(localized: "alertActionOkayTitle") , style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
}

extension StationSelectionViewController: CLLocationManagerDelegate {
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        latitude = locations.last?.coordinate.latitude
        longitude = locations.last?.coordinate.longitude
        
        fetchStations()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        fetchStations()
    }
    
}
extension StationSelectionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StationSelectionTableViewCell", for: indexPath) as! StationSelectionTableViewCell
        let station = stations[indexPath.row]
        setChargeTypeImage(cell: cell, station: station)
        cell.stationNameLabel.text =  station.stationName
        if let distanceInKM = station.distanceInKM {
            cell.distanceInKMLabel.text = String(format: "%.1f", distanceInKM) + " km"
        }
        else {
            cell.distanceInKMLabel.isHidden = true
        }
        let properSocketCount = station.socketCount - station.occupiedSocketCount
        cell.properSocketNumberLabel.text = "\(properSocketCount) / \(station.socketCount)"
        return cell
    }
    
    private func setChargeTypeImage(cell: StationSelectionTableViewCell, station: APIAllStationModel) {
        if station.hasAC && station.hasDC {
            cell.chargeTypeView.image = #imageLiteral(resourceName: "AC-DC")
        }
        else if station.hasAC {
            cell.chargeTypeView.image = #imageLiteral(resourceName: "AC")
        }
        else {
            cell.chargeTypeView.image = #imageLiteral(resourceName: "DC")
        }
    }
    
}

extension StationSelectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let station = stations[indexPath.row]
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let dateAndTimeSelectionViewController = storyBoard.instantiateViewController(withIdentifier: "DateAndTimeSelectionViewController") as! DateAndTimeSelectionViewController
        dateAndTimeSelectionViewController.selectedStation = station
        navigationController?.pushViewController(dateAndTimeSelectionViewController, animated: true)
        
    }
}
