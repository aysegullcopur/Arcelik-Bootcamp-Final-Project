//
//  SocketModel.swift
//  Charger
//
//  Created by Aysegul COPUR on 17.07.2022.
//

import Foundation

class SocketModel {
    let apiSocket: APIAvailableSocketModel
    var appointmentDateString: String
    var timeSlots: [SocketTimeSlot]

    init(apiSocket: APIAvailableSocketModel, appointmentDateString: String, timeSlots: [APITimeSlotsModel]) {
        self.apiSocket = apiSocket
        self.appointmentDateString = appointmentDateString
        self.timeSlots = timeSlots.map { SocketTimeSlot(timeString: $0.slot, isOccupied: $0.isOccupied) }
    }
}
