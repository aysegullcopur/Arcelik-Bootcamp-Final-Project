//
//  APIModels.swift
//  Charger
//
//  Created by Aysegul COPUR on 3.07.2022.
//

import Foundation

struct APILoginRequestModel: Encodable {
    let email: String
    let deviceUDID: String
}

struct APILoginResponseModel: Decodable {
    let email: String
    let token: String
    let userID: Int
}
