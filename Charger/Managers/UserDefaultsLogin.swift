//
//  UserDefaultsLogin.swift
//  Charger
//
//  Created by Aysegul COPUR on 5.07.2022.
//

import Foundation

class UserDefaultsLogin {
    static var email: String? {
        get {
            UserDefaults.standard.string(forKey: "email")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "email")
        }
    }
    static var token: String? {
        get {
            UserDefaults.standard.string(forKey: "token")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "token")
        }
    }
    static var userId: Int? {
        get {
            UserDefaults.standard.integer(forKey: "userId")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "userId")
        }
    }
}
