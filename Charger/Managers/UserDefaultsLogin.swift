//
//  UserDefaultsLogin.swift
//  Charger
//
//  Created by Aysegul COPUR on 5.07.2022.
//

import Foundation

class UserDefaultsLogin {
    static var isLoggedIn: Bool {
        get { UserDefaults.standard.bool(forKey: "userLoggedIn") }
        set { UserDefaults.standard.set(newValue, forKey: "userLoggedIn") }
    }
}
