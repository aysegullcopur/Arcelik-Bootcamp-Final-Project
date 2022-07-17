//
//  SocketTimeSlot.swift
//  Charger
//
//  Created by Aysegul COPUR on 17.07.2022.
//

import Foundation

class SocketTimeSlot {
    var timeString: String
    var isOccupied: Bool
    var isSelected: Bool = false
    
    init(timeString: String, isOccupied: Bool) {
        self.timeString = timeString
        self.isOccupied = isOccupied
    }
}
