//
//  ProfileViewController.swift
//  Charger
//
//  Created by Aysegul COPUR on 13.07.2022.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var deviceIdLabel: UILabel!
    @IBOutlet weak var logoutButton: UIButton!

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //hides left top item bar's name
        navigationController?.navigationBar.topItem?.title = ""
        navigationController?.navigationBar.tintColor = UIColor.lightGray
        // set email and deviceId texts
        emailLabel.text = UserDefaultsLogin.email!
        deviceIdLabel.text = String(UserDefaultsLogin.userId!)
    }
    
    @IBAction private func logoutButtonPressed(_sender: UIButton) {
        guard let userId = UserDefaultsLogin.userId else{
            return
        }
        
        enableUserInteraction(false)
        API.logout(userId: userId) { result in
            self.enableUserInteraction(true)
            
            switch result {
            case .success(()):
                UserDefaultsLogin.email = nil
                UserDefaultsLogin.userId = nil
                UserDefaultsLogin.token = nil
                self.navigateToLoginScreen()
            case .failure(_):
                self.presentAlert(title: String(localized: "logoutErrorMessage"))
            }
        }
    }
    
    private func presentAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: String(localized: "alertActionOkayTitle") , style: .cancel, handler: nil)
        alert.addAction(action)
        present(alert, animated: true)
    }
    
    private func enableUserInteraction(_ value: Bool) {
        // button disables
        logoutButton.isEnabled = value
        // bar button item disables
        navigationController?.navigationBar.isUserInteractionEnabled = false
    }
    // moves to login screen after button tapped
    private func navigateToLoginScreen() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController")
        navigationController?.setViewControllers([loginViewController], animated: true)
    }
}
