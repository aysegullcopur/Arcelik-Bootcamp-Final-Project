//
//  TimeSlotCollectionViewCell.swift
//  Charger
//
//  Created by Aysegul COPUR on 16.07.2022.
//

import UIKit

class TimeSlotCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var cellBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setSelected(_ isSelected: Bool) {
        cellBackgroundView.backgroundColor = isSelected ? .black : #colorLiteral(red: 0.262745098, green: 0.2862745098, blue: 0.3333333333, alpha: 1)
        cellBackgroundView.layer.borderColor = UIColor.green.cgColor
        cellBackgroundView.layer.borderWidth = isSelected ? 1 : 0
    }
    
}
