//
//  APIEndpoints.swift
//  Charger
//
//  Created by Aysegul COPUR on 3.07.2022.
//

import Foundation

enum APIEndpoint {
    case login
    case logout(userId: Int)
    case provinces
    case stations
    case stationsAvailability(stationId: Int)
    case makeAppointment
    case appointments(userId: Int)
    case cancelAppointment(appointmentId: String)
    
    var path: String {
        switch self {
        case .login:
            return "/auth/login"
        case .logout(let userId):
            return "/auth/logout/\(userId)"
        case .provinces:
            return "/provinces"
        case .stations:
            return "/stations"
        case .stationsAvailability(let stationId):
            return "/stations/\(stationId)"
        case .makeAppointment:
            return "/appointments/make"
        case .appointments(let userId):
            return "/appointments/\(userId)"
        case .cancelAppointment(let appointmentId):
            return "/appointments/cancel/\(appointmentId)"
        }
    }
}
