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

struct APIAppointmentModel: Decodable {
    let time: String
    let date: String
    let station: APIStationModel
    let stationCode: String
    let stationName: String
    let userID: Int
    let appointmentID: Int
    let socketID: Int
    let hasPassed: Bool
    
    var dateTime: String {
        return date + time
    }
    
    var socket: APISocketModel {
        return station.sockets.first(where: { $0.socketID == socketID })!
    }
}

struct APIStationModel: Decodable {
    let id: Int
    let sockets: [APISocketModel]
    let socketCount: Int
    let occupiedSocketCount: Int
    let distanceInKM: Double?
    let geoLocation: APIGeoLocation
    let services: [String]
}

struct APISocketModel: Decodable {
    let socketID: Int
    let socketType: String
    let chargeType: String
    let power: Int
    let powerUnit: String
    let socketNumber: Int
}

struct APIGeoLocation: Decodable {
    let longitude: Double
    let latitude: Double
    let province: String
    let address: String
}
