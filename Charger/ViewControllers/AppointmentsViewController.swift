//
//  AppointmentsViewController.swift
//  Charger
//
//  Created by Aysegul COPUR on 5.07.2022.
//

import UIKit
import CoreLocation

class AppointmentsViewController: UIViewController {
    
    @IBOutlet weak var appointmentsTableView: UITableView!
    @IBOutlet weak var appointmentsEmptyView: UIStackView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    let dateFormatterGet = DateFormatter()
    let dateFormatterPrint = DateFormatter()
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    let locationManager = CLLocationManager()
    var latitude: Double?
    var longitude: Double?
    
    private var passedAppointments = [APIAppointmentModel]()
    private var currentAppointments = [APIAppointmentModel]()
    private var sockets = [APISocketModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // formats date
        dateFormatterGet.dateFormat = "yyyy-MM-ddHH:mm"
        dateFormatterPrint.dateFormat = "dd MMM yyyy, HH:mm"
        //set delegates and dataSource
        appointmentsTableView.dataSource = self
        appointmentsTableView.delegate = self
        locationManager.delegate = self
        appointmentsTableView.register(AppointmentHeaderView.self, forHeaderFooterViewReuseIdentifier: "sectionHeader")
    }

    @IBAction func appointmentButtonPressed(_ sender: UIButton) {
        //move tox City Selection screen
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let citySelectionViewController = storyBoard.instantiateViewController(withIdentifier: "CitySelectionViewController")
        navigationController?.pushViewController(citySelectionViewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        appointmentsTableView.isHidden = true
        appointmentsEmptyView.isHidden = true
        configureNavigationBar()
        activityIndicator.startAnimating()
        locationManager.requestLocation()
    }
    
    private func configureNavigationBar() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        // create a new button
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(named: "User"), for: .normal)
        // add function for button
        button.addTarget(self, action: #selector(barButtonPressed), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 36),
            button.heightAnchor.constraint(equalToConstant: 36)
        ])

        let barButton = UIBarButtonItem(customView: button)
        // assign button to navigationbar
        navigationItem.leftBarButtonItem = barButton
    }
    
    private func fetchAppointments() {
        guard let userId = UserDefaultsLogin.userId else {
            return
        }
        
        activityIndicator.startAnimating()
        
        API.appointments(userId: userId, latitude: latitude, longitude: longitude) { result in
            switch result {
            case .success(let appointments):
                self.updateAppointments(appointments)
            case .failure(_):
                //TODO: handle the error
                break
            }
            self.activityIndicator.stopAnimating()
        }
    }
    
    private func updateAppointments(_ appointments: [APIAppointmentModel]) {
        appointmentsTableView.isHidden = appointments.isEmpty
        appointmentsEmptyView.isHidden = !appointments.isEmpty
        let currentDate = Date()
        passedAppointments = appointments.filter{ dateFormatterGet.date(from: $0.dateTime)! <= currentDate }
        currentAppointments = appointments.filter{ dateFormatterGet.date(from: $0.dateTime)! > currentDate }
        appointmentsTableView.reloadData()
    
    }
    
    @objc private func barButtonPressed() {
        //move to the Profile screen.
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController")
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
}

extension AppointmentsViewController: CLLocationManagerDelegate {
  
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        latitude = locations.last?.coordinate.latitude
        longitude = locations.last?.coordinate.longitude
        
        fetchAppointments()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        fetchAppointments()
    }
    
}

extension AppointmentsViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return currentAppointments.count
        }
        else if section == 1 {
            return passedAppointments.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            return dequeueCurrentAppointmentCell(tableView: tableView, indexPath: indexPath)
        }
        else if indexPath.section == 1 {
            return dequeuePassedAppointmentCell(tableView: tableView, indexPath: indexPath)
        }
        fatalError("unknown section in appointmentsTableView")
    }
    
    private func dequeueCurrentAppointmentCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentsTableViewCell", for: indexPath) as! AppointmentsTableViewCell
        cell.deleteButton.isHidden = false
        cell.alarmView.isHidden = false
        let appointment = currentAppointments[indexPath.row]
        setChargeTypeImage(cell: cell, appointment: appointment)
        // TODO: alarm settings
        //cell.alarmPowerUnitLabel.text =
        setAppointmentCell(cell: cell, appointment: appointment)
        return cell
    }
    
    private func dequeuePassedAppointmentCell(tableView: UITableView, indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AppointmentsTableViewCell", for: indexPath) as! AppointmentsTableViewCell
        let appointment = passedAppointments[indexPath.row]
        cell.alarmPowerUnitLabel.text = String(appointment.socket.power) + " " + appointment.socket.powerUnit
        cell.alarmView.isHidden = true
        cell.deleteButton.isHidden = true
        setChargeTypeImage(cell: cell, appointment: appointment)
        setAppointmentCell(cell: cell, appointment: appointment)
        return cell
    }
    
    private func setChargeTypeImage(cell: AppointmentsTableViewCell, appointment: APIAppointmentModel) {
        if appointment.socket.chargeType == "AC" {
            cell.chargeTypeView.image = #imageLiteral(resourceName: "AC")
        }
        else if appointment.socket.chargeType == "DC" {
            cell.chargeTypeView.image = #imageLiteral(resourceName: "DC")
        }
        else {
            cell.chargeTypeView.image = #imageLiteral(resourceName: "AC-DC")
        }
    }
    
    private func setAppointmentCell(cell: AppointmentsTableViewCell, appointment: APIAppointmentModel) {
        cell.stationProvinceNameLabel.text = appointment.stationName + ", " + appointment.station.geoLocation.province
        let date = dateFormatterGet.date(from: appointment.dateTime)!
        cell.dateTimeLabel.text = dateFormatterPrint.string(from: date)
        cell.socketNumberLabel.text = String(appointment.socketID)
        cell.chargeSocketTypeLabel.text = appointment.socket.chargeType + "•" + appointment.socket.socketType
    }
    
}

extension AppointmentsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if isSectionEmpty(section) {
            return nil
        }
        let headerView = appointmentsTableView.dequeueReusableHeaderFooterView(withIdentifier: "sectionHeader") as! AppointmentHeaderView
        if section == 0 {
            headerView.title.text = String(localized: "headerCurrentAppointmentsTitle")
        }
        else if section == 1 {
            headerView.title.text = String(localized: "headerPastAppointmentsTitle")
        }
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if isSectionEmpty(section) {
            return 0
        }
        return 61
    }
    
    private func isSectionEmpty(_ section: Int) -> Bool {
        return section == 0 && currentAppointments.isEmpty || section == 1 && passedAppointments.isEmpty
    }

}
