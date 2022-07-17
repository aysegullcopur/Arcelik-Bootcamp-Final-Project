//
//  AppointmentDetailViewController.swift
//  Charger
//
//  Created by Aysegul COPUR on 17.07.2022.
//

import UIKit

class AppointmentDetailViewController: UIViewController {
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var stationCodeLabel: UILabel!
    @IBOutlet weak var servicesLabel: UILabel!
    @IBOutlet weak var socketNumberLabel: UILabel!
    @IBOutlet weak var deviceTypeLabel: UILabel!
    @IBOutlet weak var socketTypeLabel: UILabel!
    @IBOutlet weak var socketPowerLabel: UILabel!
    @IBOutlet weak var appointmentDateLabel: UILabel!
    @IBOutlet weak var appointmentTimeLabel: UILabel!
    
    @IBOutlet weak var approveButton: UIButton!
    
    @IBAction func approveButtonTapped(_ sender: UIButton) {
        makeAppointment()
    }
    
    var selectedStation: APIAllStationModel?
    var selectedSocket: SocketModel?
    var selectedSocketTimeSlot: SocketTimeSlot?
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addressLabel.text = selectedStation?.geoLocation.address
        if let distance = selectedStation?.distanceInKM {
            distanceLabel.text = String(format: "%.1f", distance) + " km"
        }
        stationCodeLabel.text = selectedStation?.stationCode
        servicesLabel.text = selectedStation?.services.joined(separator: ", ")
        if let socketNumber = selectedSocket?.apiSocket.socketNumber {
            socketNumberLabel.text = String(socketNumber)
        }
        deviceTypeLabel.text = selectedSocket?.apiSocket.chargeType
        socketTypeLabel.text = selectedSocket?.apiSocket.socketType
        if let socketPower = selectedSocket?.apiSocket.power, let socketPowerUnit = selectedSocket?.apiSocket.powerUnit {
            socketPowerLabel.text = "\(socketPower) \(socketPowerUnit)"
        }
        
        appointmentDateLabel.text = selectedSocket?.appointmentDateString
        appointmentTimeLabel.text = selectedSocketTimeSlot?.timeString
    }
    
    private func presentAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: String(localized: "alertActionOkayTitle") , style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func makeAppointment() {
        guard let socket = selectedSocket, let station = selectedStation, let socketTimeSlot = selectedSocketTimeSlot, let userId = UserDefaultsLogin.userId else {
            presentAlert(title: String(localized: "genericErrorMessage"))
            return
        }

        let requestModel = APIMakeAppointmentRequestModel(
            stationID: station.id,
            socketID: socket.apiSocket.socketID,
            timeSlot: socketTimeSlot.timeString,
            appointmentDate: socket.appointmentDateString
        )
        
        view.isUserInteractionEnabled = false
        navigationController?.navigationBar.isUserInteractionEnabled = false
        
        API.makeAppointment(userId: userId, latitude: nil, longitude: nil, requestModel: requestModel, completion: { result in
            switch result {
            case .success(_):
                self.navigationController?.popToRootViewController(animated: true)
            case .failure(_):
                self.presentAlert(title: String(localized: "genericErrorMessage"))
            }
            
            self.view.isUserInteractionEnabled = false
            self.navigationController?.navigationBar.isUserInteractionEnabled = false
        })
    }
    
}
