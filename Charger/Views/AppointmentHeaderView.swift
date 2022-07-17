//
//  AppointmentHeaderView.swift
//  Charger
//
//  Created by Aysegul COPUR on 15.07.2022.
//

import UIKit

class AppointmentHeaderView: UITableViewHeaderFooterView {
    let title = UILabel()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        configureContents()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureContents() {
        title.font = .systemFont(ofSize: 17, weight: .semibold)
        title.textColor = #colorLiteral(red: 0.7176470588, green: 0.7411764706, blue: 0.7960784314, alpha: 1)
        title.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(title)
        
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            title.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20),
            title.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 15),
            title.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
}
