//
//  LaunchViewController.swift
//  Charger
//
//  Created by Aysegul COPUR on 29.06.2022.
//

import UIKit
import CoreLocation

class LaunchViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return true
    }

    private lazy var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
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
        if UserDefaultsLogin.userLoginModel == nil {
            // moves to login screen
            let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
            navigationController?.setViewControllers([loginViewController], animated: true)
            
        }
        else {
            // moves to appointments screen
            let appointmentsViewController = storyBoard.instantiateViewController(withIdentifier: "AppointmentsViewController")
            navigationController?.setViewControllers([appointmentsViewController], animated: true)
                        
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
