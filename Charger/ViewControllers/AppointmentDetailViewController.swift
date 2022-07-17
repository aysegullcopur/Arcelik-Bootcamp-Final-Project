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
}
