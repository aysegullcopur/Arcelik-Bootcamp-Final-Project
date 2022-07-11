//
//  UserDefaultsLogin.swift
//  Charger
//
//  Created by Aysegul COPUR on 5.07.2022.
//

import Foundation

class UserDefaultsLogin {
    static var userLoginModel: APILoginResponseModel? {
        get { UserDefaults.standard.object(forKey: "userLoginModel") as? APILoginResponseModel }
        set { UserDefaults.standard.set(newValue, forKey: "userLoginModel") }
    }
}
