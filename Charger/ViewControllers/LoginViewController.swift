//
//  LogginViewController.swift
//  Charger
//
//  Created by Aysegul COPUR on 5.07.2022.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!

    override var prefersStatusBarHidden: Bool {
        return false
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Adds attributed placeholder to change default color.
        emailTextField.attributedPlaceholder = NSAttributedString(
            string: String(localized: "emailTextFieldPlaceholder"),
            attributes: [
                .font: UIFont.systemFont(ofSize: 14),
                .foregroundColor: #colorLiteral(red: 0.7176470588, green: 0.7411764706, blue: 0.7960784314, alpha: 1)
            ]
        )
        emailTextField.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
    }
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let uuid = UIDevice.current.identifierForVendor?.uuidString else {
            presentAlert(title: String(localized: "genericErrorMessage"))
            return
        }
        
        guard let email = emailTextField.text, !email.isEmpty else {
            presentAlert(title: String(localized: "emptyEmailErrorMessage"))
            return
        }
        
        enableUserInteraction(false)
        
        API.login(email: email, deviceUDID: uuid) { result in
            self.enableUserInteraction(true)
            
            switch result {
            case .success(let responseModel):
                UserDefaultsLogin.email = responseModel.email
                UserDefaultsLogin.token = responseModel.token
                UserDefaultsLogin.userId = responseModel.userID
                
                self.navigateToAppointmentsScreen()
            case .failure(_):
                self.presentAlert(title: String(localized: "genericErrorMessage"))
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
        view.isUserInteractionEnabled = value
        loginButton.isEnabled = value
    }
    
    private func navigateToAppointmentsScreen() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let appointmentsViewController = storyBoard.instantiateViewController(withIdentifier: "AppointmentsViewController")
        navigationController?.setViewControllers([appointmentsViewController], animated: true)
    }

}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.endEditing(true)
        return true
    }
    
}
