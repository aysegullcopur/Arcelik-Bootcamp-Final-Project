//
//  MainNavigationController.swift
//  Charger
//
//  Created by Aysegul COPUR on 11.07.2022.
//

import UIKit

class MainNavigationController: UINavigationController {
    
    override var childForStatusBarHidden: UIViewController? {
        return topViewController
    }
    
    override var childForStatusBarStyle: UIViewController? {
        return topViewController
    }
    
    private var statusBarBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = #colorLiteral(red: 0.262745098, green: 0.2862745098, blue: 0.3333333333, alpha: 1)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(statusBarBackgroundView)
        
        NSLayoutConstraint.activate([
            statusBarBackgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            statusBarBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            statusBarBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor),
            statusBarBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor),
        ])
    }
    
    override func setNavigationBarHidden(_ hidden: Bool, animated: Bool) {
        super.setNavigationBarHidden(hidden, animated: animated)
        
        statusBarBackgroundView.isHidden = hidden
    }
    
}
