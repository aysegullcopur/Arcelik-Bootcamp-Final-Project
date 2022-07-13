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
    
    @IBAction func appointmentButtonPressed(_ sender: UIButton) {
        //move tox City Selection screen
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let citySelectionViewController = storyBoard.instantiateViewController(withIdentifier: "CitySelectionViewController")
        navigationController?.pushViewController(citySelectionViewController, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        //create a new button
        let button: UIButton = UIButton(type: .custom)
        button.setImage(UIImage(named: "User"), for: .normal)
        //add function for button
        button.addTarget(self, action: #selector(barButtonPressed), for: .touchUpInside)
        NSLayoutConstraint.activate([
            button.widthAnchor.constraint(equalToConstant: 36),
            button.heightAnchor.constraint(equalToConstant: 36)
        ])

        let barButton = UIBarButtonItem(customView: button)
        //assign button to navigationbar
        self.navigationItem.leftBarButtonItem = barButton
    }
    
    @objc private func barButtonPressed() {
        //move to the Profile screen.
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let profileViewController = storyBoard.instantiateViewController(withIdentifier: "ProfileViewController")
        navigationController?.pushViewController(profileViewController, animated: true)
    }
    
}
