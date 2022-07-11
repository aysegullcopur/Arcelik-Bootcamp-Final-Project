//
//  AppointmentsViewController.swift
//  Charger
//
//  Created by Aysegul COPUR on 5.07.2022.
//

import UIKit

class AppointmentsViewController: UIViewController {
    
    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
}
