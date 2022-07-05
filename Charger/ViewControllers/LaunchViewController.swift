//
//  LaunchViewController.swift
//  Charger
//
//  Created by Aysegul COPUR on 29.06.2022.
//

import UIKit
import CoreLocation

class LaunchViewController: UIViewController {

    private lazy var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
    }
    
    func requestLocationPermissionIfRequired() {
        switch locationManager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        default:
            onLocationPermissionDetermined()
        }
    }
    
    func onLocationPermissionDetermined() {
        requestNotificationPermissionRequired()
    }
    
    func requestNotificationPermissionRequired() {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge], completionHandler: onNotificationPermissionCompletion)
    }
    
    func onNotificationPermissionCompletion(result: Bool, error: Error?) {
        DispatchQueue.main.async(execute: navigateToNextScreen)
    }
    
    func navigateToNextScreen() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if UserDefaultsLogin.isLoggedIn {
            //let appointmentsViewController = storyBoard.instantiateViewController(withIdentifier: "appointmentsViewController")
            //navigationController?.setViewControllers([appointmentsViewController], animated: true)
        }
        else {
            let loginViewController = storyBoard.instantiateViewController(withIdentifier: "loginViewController")
            navigationController?.setViewControllers([loginViewController], animated: false)
        }
//        if let uuid = UIDevice.current.identifierForVendor?.uuidString {
//            //TODO: create APILoginRequestModel
//            let email = "aysegullcopur@gmail.com"
//            API.login(email: email, deviceUDID: uuid)
//        }
    }
    
}

extension LaunchViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        requestLocationPermissionIfRequired()
    }
    
}
