//
//  CitySelectionViewController.swift
//  Charger
//
//  Created by Aysegul COPUR on 15.07.2022.
//

import UIKit

class CitySelectionViewController: UIViewController {
    
    @IBOutlet weak var citySelectionTableView: CitySelectionTableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    private var provinces: [String] = []
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //hides left top item bar's name
        citySelectionTableView.tableView.dataSource = self
        citySelectionTableView.tableView.delegate = self
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor.lightGray

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        citySelectionTableView.tableView.isHidden = true
        activityIndicator.startAnimating()
        API.getProvinces(userId: UserDefaultsLogin.userId!) { result in
            switch result {
            case .success(let provinces):
                self.provinces = provinces
                self.citySelectionTableView.tableView.reloadData()
            case .failure(_):
                self.presentAlert(title: String(localized: "genericErrorMessage"))
            }
            self.citySelectionTableView.tableView.isHidden = false
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

extension CitySelectionViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return provinces.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CitySelectionTableViewCell", for: indexPath) as! CitySelectionTableViewCell
        
        cell.cityLabel.text = provinces[indexPath.row]
        return cell
    }
}

extension CitySelectionViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cityName = provinces[indexPath.row]
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let stationSelectionViewController = storyBoard.instantiateViewController(withIdentifier: "StationSelectionViewController") as! StationSelectionViewController
        stationSelectionViewController.province = cityName
        navigationController?.pushViewController(stationSelectionViewController, animated: true)
        
    }
}


//TODO: Search Bar
extension CitySelectionViewController: UISearchBarDelegate {

func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
}

func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
}

}
